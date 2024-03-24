import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name = 'John Doe';
  String? _phone = '+1 234 567 890';
  String? _email = 'johndoe@example.com';
  String? _description = 'Hello, I am John Doe! I love coding and exploring new technologies.';
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 10,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(64, 105, 225, 1),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _showImagePickerOptions,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _imageFile != null
                  ? FileImage(_imageFile!)
                  : const NetworkImage('https://example.com/profile_image.jpg') as ImageProvider,
            ),
          ),
          buildUserInfoDisplay(_name, 'Name', () => _navigateToEditPage(EditNamePage())),
          buildUserInfoDisplay(_phone, 'Phone', () => _navigateToEditPage(EditPhonePage())),
          buildUserInfoDisplay(_email, 'Email', null),
          Expanded(
            child: buildAbout(_description),
            flex: 4,
          ),
        ],
      ),
    );
  }

  Widget buildUserInfoDisplay(String? getValue, String title, VoidCallback? onEdit) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        Container(
          width: 350,
          height: 40,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  getValue ?? '',
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 40.0,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget buildAbout(String? description) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell Us About Yourself',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 1),
        Container(
          width: 350,
          height: 200,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                description ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  void _navigateToEditPage(Widget editPage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => editPage,
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          // Update the corresponding field with the edited value
        });
      }
    });
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}

// Placeholder edit pages
class EditNamePage extends StatefulWidget {
  @override
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            ElevatedButton(
              onPressed: _saveAndNavigateBack,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAndNavigateBack() {
    Navigator.pop(context, _nameController.text);
  }
}

class EditPhonePage extends StatefulWidget {
  @override
  _EditPhonePageState createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
              ),
            ),
            ElevatedButton(
              onPressed: _saveAndNavigateBack,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAndNavigateBack() {
    Navigator.pop(context, _phoneController.text);
  }
}