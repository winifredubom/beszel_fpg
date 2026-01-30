import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/theme_extensions.dart';

class AddSystemDialog extends StatefulWidget {
  const AddSystemDialog({super.key});

  @override
  State<AddSystemDialog> createState() => _AddSystemDialogState();
}

class _AddSystemDialogState extends State<AddSystemDialog> {
  bool _isBinary = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
        children: [
          const Expanded(child: Text('Add New System')),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            child: Icon(
              CupertinoIcons.xmark,
              color: context.textColor,
              size: 20,
            ),
          ),
        ],
      ),
      content: Column(
        children: [
          const SizedBox(height: 16),
          // Installation type selector
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: context.textColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    borderRadius: BorderRadius.circular(6),
                    color: _isBinary ? context.surfaceColor : null,
                    onPressed: () => setState(() => _isBinary = true),
                    child: Text(
                      'Binary',
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    borderRadius: BorderRadius.circular(6),
                    color: !_isBinary ? context.surfaceColor : null,
                    onPressed: () => setState(() => _isBinary = false),
                    child: Text(
                      'Docker',
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'The agent must be running on the system to connect. Copy the installation command for the agent below.',
            style: TextStyle(
              color: context.textColor.withOpacity(0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Form fields
          _buildTextField(
            controller: _nameController,
            placeholder: 'Name',
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _hostController,
            placeholder: 'Host / IP',
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _portController,
            placeholder: 'Port',
            value: '45876',
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _keyController,
            placeholder: 'Public Key',
            value: 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5',
            suffix: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _keyController.text));
              },
              child: Icon(
                CupertinoIcons.doc_on_doc,
                color: context.textColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Linux command
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.textColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Copy Linux command',
                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(
                            text: 'curl -sSL https://example.com/install.sh | sudo bash',
                          ),
                        );
                      },
                      child: Icon(
                        CupertinoIcons.doc_on_doc,
                        color: context.textColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'curl -sSL https://example.com/install.sh | sudo bash',
                  style: TextStyle(
                    color: context.textColor.withOpacity(0.7),
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            // TODO: Implement add system
            Navigator.pop(context);
          },
          child: const Text('Add system'),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    String? value,
    Widget? suffix,
  }) {
    if (value != null) {
      controller.text = value;
    }

    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      decoration: BoxDecoration(
        color: context.textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      style: TextStyle(
        color: context.textColor,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      suffix: suffix,
    );
  }
}