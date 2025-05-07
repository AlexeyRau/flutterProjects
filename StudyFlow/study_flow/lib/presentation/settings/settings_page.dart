import 'package:flutter/material.dart';
import 'package:study_flow/core/constants/group_data.dart';
import 'package:study_flow/data/services/settings_service.dart';
import 'package:study_flow/core/widgets/custom_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selectedGroupName;

  @override
  void initState() {
    super.initState();
    _loadSelectedGroup();
  }

  Future<void> _loadSelectedGroup() async {
    final code = await SettingsService.getSelectedGroupCode();
    if (code != null) {
      final name = GroupData.groups.entries
          .firstWhere((entry) => entry.value == code,
              orElse: () => const MapEntry('ФИТ-231', '850'))
          .key;
      setState(() {
        _selectedGroupName = name;
      });
    }
  }

  Future<void> _selectGroup(BuildContext context) async {
    final selectedName = await showDialog<String>(
      context: context,
      builder: (context) => _GroupSelectDialog(
        currentSelection: _selectedGroupName,
      ),
    );
    if (selectedName != null && selectedName.isNotEmpty) {
      final code = GroupData.groups[selectedName];
      if (code != null) {
        await SettingsService.setSelectedGroupCode(code);
        setState(() {
          _selectedGroupName = selectedName;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Настройки', context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Выберите группу:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectGroup(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(text: _selectedGroupName),
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupSelectDialog extends StatefulWidget {
  final String? currentSelection;

  const _GroupSelectDialog({this.currentSelection});

  @override
  State<_GroupSelectDialog> createState() => _GroupSelectDialogState();
}

class _GroupSelectDialogState extends State<_GroupSelectDialog> {
  late List<String> _filteredGroups;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredGroups = GroupData.groups.keys.toList();
    _searchController.addListener(_filterGroups);
  }

  void _filterGroups() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGroups = GroupData.groups.keys
          .where((name) => name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выберите группу'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Поиск...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredGroups.length,
                itemBuilder: (context, index) {
                  final groupName = _filteredGroups[index];
                  return RadioListTile<String>(
                    title: Text(groupName),
                    value: groupName,
                    groupValue: widget.currentSelection,
                    onChanged: (value) {
                      Navigator.pop(context, value);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}