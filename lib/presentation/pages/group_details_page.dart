import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanoid/nanoid.dart';
import 'package:nexus_dashboard/domain/entities/group_entity.dart';
import 'package:nexus_dashboard/domain/entities/light_entity.dart';
import 'package:nexus_dashboard/presentation/bloc/group_details/group_details_bloc.dart';
import 'package:nexus_dashboard/presentation/bloc/theme/theme_bloc.dart';
import 'package:nexus_dashboard/presentation/widgets/common_app_bar.dart';

class GroupDetailsPage extends StatefulWidget {
  final GroupEntity? group; // Make group optional for creation mode

  const GroupDetailsPage({
    super.key,
    this.group,
  });

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _idController;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  
  // Selected lights for batch adding
  final Set<String> _selectedLights = {};

  @override
  void initState() {
    super.initState();
    
    if (widget.group != null) {
      // Edit mode - populate with existing group data
      _idController = TextEditingController(text: widget.group!.id);
      _nameController = TextEditingController(text: widget.group!.name);
      _descriptionController = TextEditingController(text: widget.group!.description);
      
      // Load group details only - lights will be loaded after details are loaded
      context.read<GroupDetailsBloc>().add(LoadGroupDetails(groupId: widget.group!.id));
    } else {
      // Create mode - initialize with defaults
      _idController = TextEditingController(text: nanoid(10)); // Generate a new ID
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.group != null
            ? 'Edit Group: ${widget.group!.name}'
            : 'Create Group',
        onColorChanged: (color) {
          context.read<ThemeBloc>().add(ChangeSeedColor(color));
        },
        actions: [],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GroupDetailsBloc, GroupDetailsState>(
            listener: (context, state) {
              if (state is GroupDetailsOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate back to the group list page after successful update
                Navigator.pop(context, true); // Return true to indicate refresh needed
              } else if (state is GroupDetailsOperationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is GroupLightsOperationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is GroupDetailsDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context, true); // Return true to indicate refresh needed
              } else if (state is GroupDetailsLoaded && widget.group != null) {
                // Load lights after group details are loaded
                print('DEBUG: GroupDetailsLoaded state detected, loading lights');
                context.read<GroupDetailsBloc>().add(
                      LoadGroupLights(groupId: widget.group!.id),
                    );
              }
            },
          ),
        ],
        child: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
          builder: (context, state) {
            if (state is GroupDetailsLoading || state is GroupDetailsOperationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupDetailsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              // For both GroupDetailsLoaded and GroupLightsLoaded states
              return _buildDetailsForm(state);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDetailsForm(GroupDetailsState state) {
    // Debug state type
    print('DEBUG: Building details form with state: ${state.runtimeType}');
    
    if (state is GroupLightsLoaded) {
      print('DEBUG: GroupLightsLoaded state has ${state.groupLights.length} group lights and ${state.ungroupedLights.length} ungrouped lights');
      if (state.ungroupedLights.isEmpty) {
        print('DEBUG: Ungrouped lights list is empty');
      } else {
        print('DEBUG: First ungrouped light: ${state.ungroupedLights.first.name} (${state.ungroupedLights.first.ip})');
      }
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Info Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Group Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ID field (read-only)
                    TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        labelText: 'Group ID',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color(0xFFF5F5F5),
                      ),
                      readOnly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    // Name field
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Group Name',
                        hintText: 'e.g., Kitchen',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a group name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Description field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'e.g., Kitchen lights group',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.group != null) // Only show delete for existing groups
                          OutlinedButton.icon(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text('Delete', style: TextStyle(color: Colors.red)),
                            onPressed: _showDeleteConfirmation,
                          ),
                        if (widget.group != null)
                          const SizedBox(width: 8),
                        FilledButton.icon(
                          icon: const Icon(Icons.save),
                          label: Text(widget.group != null ? 'Save Changes' : 'Create Group'),
                          onPressed: _saveGroup,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lights Management Section (only for GroupLightsLoaded state)
          if (state is GroupLightsLoaded) ...[
            // Ungrouped Lights Section
            const Text(
              'Ungrouped Lights',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Drag lights to add them to the group',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: DragTarget<LightEntity>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: candidateData.isNotEmpty
                            ? Colors.green
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade50,
                    ),
                    child: state.ungroupedLights.isEmpty
                        ? const Center(
                            child: Text('No ungrouped lights available'),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.ungroupedLights.length,
                            itemBuilder: (context, index) {
                              final light = state.ungroupedLights[index];
                              return Draggable<LightEntity>(
                                data: light,
                                feedback: _buildLightItem(light, true),
                                childWhenDragging: _buildLightItem(light, true, opacity: 0.5),
                                child: _buildLightItem(light, true),
                              );
                            },
                          ),
                  );
                },
                onAcceptWithDetails: (details) {
                  // Handle light being dropped from group to ungrouped
                  final light = details.data;
                  if (widget.group != null) {
                    context.read<GroupDetailsBloc>().add(
                          RemoveLightFromGroup(
                            groupId: widget.group!.id,
                            lightIp: light.ip,
                          ),
                        );
                  }
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Group Lights Section
            const Text(
              'Lights in this Group',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Drag lights to remove them from the group',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: DragTarget<LightEntity>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: candidateData.isNotEmpty
                            ? Colors.green
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: state.groupLights.isEmpty
                        ? const Center(
                            child: Text('No lights in this group'),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.groupLights.length,
                            itemBuilder: (context, index) {
                              final light = state.groupLights[index];
                              return Draggable<LightEntity>(
                                data: light,
                                feedback: _buildLightItem(light, false),
                                childWhenDragging: _buildLightItem(light, false, opacity: 0.5),
                                child: _buildLightItem(light, false),
                              );
                            },
                          ),
                  );
                },
                onAcceptWithDetails: (details) {
                  // Handle light being dropped from ungrouped to group
                  final light = details.data;
                  if (widget.group != null) {
                    context.read<GroupDetailsBloc>().add(
                          AddLightToGroup(
                            groupId: widget.group!.id,
                            lightIp: light.ip,
                          ),
                        );
                  }
                },
              ),
            ),
          ],
          
          // Loading indicator for lights
          if (state is GroupLightsLoading)
            const Center(child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            )),
            
          // Error message for lights
          if (state is GroupLightsError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text('Error loading lights: ${state.message}'),
              ),
            ),
        ],
      ),
    );
  }

  // Toggle light selection for batch adding
  void _toggleLightSelection(String lightIp) {
    setState(() {
      if (_selectedLights.contains(lightIp)) {
        _selectedLights.remove(lightIp);
      } else {
        _selectedLights.add(lightIp);
      }
    });
  }

  // Add all selected lights to the group
  void _addSelectedLightsToGroup() {
    if (widget.group == null || _selectedLights.isEmpty) return;
    
    // Show loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Adding lights to group...'),
        duration: Duration(seconds: 1),
      ),
    );
    
    // Add each selected light to the group
    for (final lightIp in _selectedLights) {
      context.read<GroupDetailsBloc>().add(
        AddLightToGroup(
          groupId: widget.group!.id,
          lightIp: lightIp,
        ),
      );
    }
    
    // Clear selection after adding
    setState(() {
      _selectedLights.clear();
    });
  }

  // Build a light item widget for the drag and drop lists
  Widget _buildLightItem(LightEntity light, bool isUngrouped, {double opacity = 1.0, bool selected = false}) {
    final Color bgColor = selected
        ? Colors.blue.shade100
        : isUngrouped
            ? Colors.grey.shade100
            : Colors.blue.shade50;
    
    final Color borderColor = selected
        ? Colors.blue
        : isUngrouped
            ? Colors.grey.shade400
            : Colors.blue.shade200;
    
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 90,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb,
              color: light.state.isOn ? Colors.amber : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              light.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              light.ip,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Save or update the group
  void _saveGroup() {
    if (!_formKey.currentState!.validate()) return;

    if (widget.group != null) {
      // Update existing group - use the original group ID
      print('DEBUG: Updating existing group with ID: ${widget.group!.id}');
      context.read<GroupDetailsBloc>().add(
            UpdateGroupDetails(
              groupId: widget.group!.id, // Use original group ID, not from controller
              name: _nameController.text,
              description: _descriptionController.text,
            ),
          );
    } else {
      // Create new group - use CreateGroupDetails event
      print('DEBUG: Creating new group with ID: ${_idController.text}');
      context.read<GroupDetailsBloc>().add(
            CreateGroupDetails(
              groupId: _idController.text,
              name: _nameController.text,
              description: _descriptionController.text,
            ),
          );
      // The listener in build() will handle navigation after successful creation
    }
  }

  // Show delete confirmation dialog
  Future<void> _showDeleteConfirmation() async {
    // Only allow deletion for existing groups
    if (widget.group == null) return;
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          icon: const Icon(Icons.delete_forever, color: Colors.red, size: 36),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete the group "${widget.group!.name}"?'),
                const SizedBox(height: 8),
                const Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red[100],
                foregroundColor: Colors.red[900],
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GroupDetailsBloc>().add(
                      DeleteGroupDetails(groupId: widget.group!.id),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}