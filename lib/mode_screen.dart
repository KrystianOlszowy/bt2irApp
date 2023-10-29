import 'package:flutter/material.dart';
import 'tv_model.dart';

class ModeScreen extends StatefulWidget {
  const ModeScreen({super.key});

  @override
  ModeScreenState createState() => ModeScreenState();
}

class ModeScreenState extends State<ModeScreen> {
  Set<TVModel> tvModels = {};
  static final mantaTvModel = TVModel("Manta (default)");
  static TVModel selectedTVModel = mantaTvModel;

  final nameController = TextEditingController();
  static Map<String, TextEditingController> buttonIrCodeController = {
    'zero': TextEditingController(),
    'one': TextEditingController(),
    'two': TextEditingController(),
    'three': TextEditingController(),
    'four': TextEditingController(),
    'five': TextEditingController(),
    'six': TextEditingController(),
    'seven': TextEditingController(),
    'eight': TextEditingController(),
    'nine': TextEditingController(),
    'power': TextEditingController(),
    'mute': TextEditingController(),
    'channelUp': TextEditingController(),
    'channelDown': TextEditingController(),
    'menu': TextEditingController(),
    'okay': TextEditingController(),
    'moveUp': TextEditingController(),
    'moveDown': TextEditingController(),
    'moveLeft': TextEditingController(),
    'moveright': TextEditingController(),
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadTVModels();
  }

  Future<void> loadTVModels() async {
    tvModels.addAll(await SharedPrefs.getTVModels());
    tvModels.add(mantaTvModel);
    saveTVModels();
    nameController.text = selectedTVModel.name;
    buttonIrCodeController['zero']?.text =
        selectedTVModel.zero.getIrCode().toRadixString(16);
    setState(() {});
  }

  Future<void> saveTVModels() async {
    await SharedPrefs.saveTVModels(tvModels.toList());
  }

  Future<void> addTVModel(TVModel tvModel) async {
    tvModels.add(tvModel);
    saveTVModels();
    setState(() {
      selectedTVModel = tvModel;
    });
  }

  Future<void> removeTVModel(TVModel tvModel) async {
    if (tvModel.name != "Manta (default)") {
      tvModels.remove(tvModel);
      saveTVModels();
      loadTVModels();
      setState(() {
        selectedTVModel = tvModels.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose your TV model:'),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              DropdownButton<TVModel>(
                value: selectedTVModel,
                hint: const Text("Choose your TV model"),
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: (TVModel? newValue) {
                  setState(() {
                    selectedTVModel = newValue ?? mantaTvModel;
                    nameController.text = newValue?.name ?? 'Error';
                    buttonIrCodeController['zero']?.text = newValue?.zero
                            .getIrCode()
                            .toRadixString(16)
                            .toUpperCase() ??
                        '';
                  });
                },
                items:
                    tvModels.map<DropdownMenuItem<TVModel>>((TVModel tvModel) {
                  return DropdownMenuItem<TVModel>(
                      value: tvModel, child: Text(tvModel.name));
                }).toList(),
              ),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter TV model',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'TV model name cannnot be empty';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: buttonIrCodeController['zero'],
                decoration: const InputDecoration(
                  hintText: 'Enter IR code in hexadecimal',
                ),
              ),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    TVModel newTVModel = TVModel(nameController.text);
                    newTVModel.zero.setIrCode(int.parse(
                        buttonIrCodeController['zero']?.text.toLowerCase() ??
                            'fff',
                        radix: 16));
                    addTVModel(newTVModel);
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  removeTVModel(selectedTVModel);
                },
                child: const Text('Delete'),
              ),
            ])));
  }
}
