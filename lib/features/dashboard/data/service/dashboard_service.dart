import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_provider.dart';
/// Optional manifest URL that returns a JSON map of locale codes to asset URLs.
/// Example structure:
/// { "de_DE": "https://beszel.flexipgroup.com/assets/de-BuT7B2oz.js", "hu_HU": "https://beszel.flexipgroup.com/assets/hu-5fIoL_ih.js" }
const String languageAssetsManifestUrl = 'https://beszel.flexipgroup.com/assets/i18n-manifest.json';

/// Loads the language assets manifest (if present) and returns a mapping.
final languageAssetsManifestProvider = FutureProvider<Map<String, String>>((ref) async {
	final dio = ref.read(dioProvider);
	try {
		final res = await dio.get(languageAssetsManifestUrl, options: Options(responseType: ResponseType.json));
		final data = res.data;
		if (data is Map) {
			// Normalize values to strings.
			return data.map((k, v) => MapEntry(k.toString(), v.toString()));
		}
	} catch (e) {
		debugPrint('ℹ️ Manifest not available or failed to load: $e');
	}
	return {};
});

/// Fetches translations from a JS asset URL and returns a key→value map.
final translationsProvider = FutureProvider.family<Map<String, String>, String>((ref, assetUrl) async {
	final dio = ref.read(dioProvider);

	final Response response = await dio.get(
		assetUrl,
		options: Options(responseType: ResponseType.plain),
	);

	final jsText = response.data is String ? response.data as String : response.data.toString();
	final map = _parseJsTranslations(jsText);
	debugPrint('🌐 Translations loaded from $assetUrl: ${map.length} entries');
	return map;
});

/// Attempts to parse a JS module that contains an object with string translations.
/// Supported common patterns:
/// - `export default { ... }`
/// - `const t = { ... }; export { t as default }`
/// - `var translations = { ... };`
Map<String, String> _parseJsTranslations(String js) {
	// Try to capture an object literal following common bundler outputs.
	String? objectText;

	final exportDefault = RegExp(r"export\s+default\s*({[\s\S]*?})\s*;?");
	final constAssign = RegExp(r"const\s+\w+\s*=\s*({[\s\S]*?})\s*;?");
	final varAssign = RegExp(r"var\s+\w+\s*=\s*({[\s\S]*?})\s*;?");

	final m1 = exportDefault.firstMatch(js);
	if (m1 != null) {
		objectText = m1.group(1);
	} else {
		final m2 = constAssign.firstMatch(js);
		if (m2 != null) {
			objectText = m2.group(1);
		} else {
			final m3 = varAssign.firstMatch(js);
			if (m3 != null) {
				objectText = m3.group(1);
			}
		}
	}

	// Fallback: attempt to get the first top-level object-like segment.
	objectText ??= _extractFirstObject(js);
	if (objectText == null) return {};

	// Heuristic: many assets already use JSON with double quotes.
	// Try JSON decode directly.
	try {
		final raw = jsonDecode(objectText);
		if (raw is Map) {
			return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
		}
	} catch (_) {
		// If JSON failed, normalize some JS differences:
		// - Replace single quotes with double quotes (best-effort)
		// - Remove trailing commas
		// - Remove comments
		var normalized = objectText;
		normalized = normalized.replaceAll(RegExp(r"//.*"), "");
		normalized = normalized.replaceAll(RegExp(r"/\*[\s\S]*?\*/"), "");
		normalized = normalized.replaceAll(RegExp(r",\s*}"), "}");
		normalized = normalized.replaceAll(RegExp(r",\s*]"), "]");
		normalized = _replaceSingleQuotesWithDouble(normalized);
		try {
			final raw = jsonDecode(normalized);
			if (raw is Map) {
				return raw.map((k, v) => MapEntry(k.toString(), v.toString()));
			}
		} catch (e) {
			debugPrint('⚠️ Failed to parse translations: $e');
		}
	}
	return {};
}

String? _extractFirstObject(String input) {
	final start = input.indexOf('{');
	if (start == -1) return null;
	int depth = 0;
	for (int i = start; i < input.length; i++) {
		final ch = input[i];
		if (ch == '{') depth++;
		if (ch == '}') {
			depth--;
			if (depth == 0) {
				return input.substring(start, i + 1);
			}
		}
	}
	return null;
}

String _replaceSingleQuotesWithDouble(String s) {
	// Best-effort: convert '...': '...' pairs to "...": "..."
	// Avoid touching apostrophes inside words by targeting quote contexts.
	s = s.replaceAllMapped(RegExp(r"'(\s*:)"), (m) => '"${m.group(1)}'); // keys ending with ':'
	s = s.replaceAllMapped(RegExp(r"(:\s*)'(.*?)'"), (m) => '${m.group(1)}"${m.group(2)}"'); // values
	// Also convert simple quoted keys 'key': value
	s = s.replaceAllMapped(RegExp(r"'(.*?)'\s*:"), (m) => '"${m.group(1)}":');
	return s;
}

