import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'tv_model.dart';

class ModelScreen extends StatefulWidget {
  const ModelScreen({super.key});

  @override
  ModelScreenState createState() => ModelScreenState();
}

class ModelScreenState extends State<ModelScreen> {
  static final emptyTvModel = TVModel();
  static final mantaTvModel = TVModel();
  static TVModel selectedTVModel = emptyTvModel;
  final List<DropdownMenuEntry<TVModel>> _dropdownMenuEntries = [];
  Set<TVModel> tvModels = {};
  bool _isLoadingModels = false;

  final nameController = TextEditingController();
  final modelSelectionController = TextEditingController();
  static Map<String, TextEditingController> buttonIrCodeControllers = {
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
    'volumeUp': TextEditingController(),
    'volumeDown': TextEditingController(),
    'channelUp': TextEditingController(),
    'channelDown': TextEditingController(),
    'menu': TextEditingController(),
    'okay': TextEditingController(),
    'moveUp': TextEditingController(),
    'moveDown': TextEditingController(),
    'moveLeft': TextEditingController(),
    'moveRight': TextEditingController(),
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadTVModels();
  }

  void loadTVModels() async {
    setState(() {
      _isLoadingModels = true;
    });

    tvModels.add(emptyTvModel);

    initMantaTvModel();
    tvModels.add(mantaTvModel);

    tvModels.addAll(await SharedPrefs.getTVModels());

    setState(() {
      _dropdownMenuEntries.addAll(getMenuEntries());
      updateFormTextFields();
      _isLoadingModels = false;
    });
    saveTVModels();
  }

  Future<void> saveTVModels() async {
    await SharedPrefs.saveTVModels(tvModels.toList());
  }

  List<DropdownMenuEntry<TVModel>> getMenuEntries() {
    return tvModels.map<DropdownMenuEntry<TVModel>>((TVModel tvModel) {
      return DropdownMenuEntry<TVModel>(
          value: tvModel,
          label: (tvModel.name != '') ? tvModel.name : 'Add new model');
    }).toList();
  }

  Future<void> addNewTVModel() async {
    if (_formKey.currentState!.validate()) {
      TVModel newTvModel = TVModel(name: nameController.text);
      setTvModelIrCodes(newTvModel);

      if (tvModels.add(newTvModel)) {
        await SharedPrefs.addTVModel(newTvModel);
        showNewTvModelAddedMessage();
        setState(() {
          selectedTVModel = newTvModel;
          TVModelHandle.selectedTVModel = selectedTVModel;
          updateFormTextFields();
          _dropdownMenuEntries.add(
              DropdownMenuEntry(value: newTvModel, label: newTvModel.name));
        });
      } else {
        showTvModelAlreadyExistsMessage();
      }
    }
  }

  Future<void> removeTVModel(TVModel tvModel) async {
    if (tvModel.name != "" && tvModel.name != "Manta") {
      if (tvModels.remove(tvModel)) {
        await SharedPrefs.removeTVModel(tvModel);
        showTvModelRemovedMessage();
        setState(() {
          selectedTVModel = tvModels.first;
          _dropdownMenuEntries.clear();
          _dropdownMenuEntries.addAll(getMenuEntries());
          updateFormTextFields();
          TVModelHandle.selectedTVModel = selectedTVModel;
        });
      } else {
        showTvModelNotExistsMessage();
      }
    } else {
      showCannotDeleteDefaultMessage();
    }
  }

  Future<void> saveChangesToTVModel(TVModel tvModel) async {
    if (tvModel.name == "" || tvModel.name == "Manta") {
      showCannotChangeDefaultMessage();
      return;
    }

    if (_formKey.currentState!.validate()) {
      TVModel changedTvModel = TVModel(name: nameController.text);

      if (changedTvModel.name != tvModel.name) {
        showUseAddNewButtonMessage();
        return;
      }

      setTvModelIrCodes(changedTvModel);

      tvModels.remove(tvModel);
      await SharedPrefs.removeTVModel(tvModel);

      tvModels.add(changedTvModel);
      await SharedPrefs.addTVModel(changedTvModel);

      showTvModelSuccessfullyChangedMessage();

      setState(() {
        selectedTVModel = changedTvModel;
        TVModelHandle.selectedTVModel = selectedTVModel;
        updateFormTextFields();
        _dropdownMenuEntries.clear();
        _dropdownMenuEntries.addAll(getMenuEntries());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const String hintTextIrCodes = 'Enter HEX IR code';
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select or set up your TV model:'),
        ),
        body: _isLoadingModels
            ? null
            : Form(
                key: _formKey,
                child: Column(children: [
                  DropdownMenu<TVModel>(
                    controller: modelSelectionController,
                    initialSelection: selectedTVModel,
                    onSelected: (TVModel? newValue) {
                      setState(() {
                        selectedTVModel = newValue ?? selectedTVModel;
                        TVModelHandle.selectedTVModel = selectedTVModel;
                        updateFormTextFields();
                      });
                    },
                    dropdownMenuEntries: _dropdownMenuEntries,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.tv),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("TV model:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
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
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.power_settings_new_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Power:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['power'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.volume_off_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Mute:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['mute'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.plus_one_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Channel Up:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller:
                                      buttonIrCodeControllers['channelUp'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.exposure_minus_1_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Channel Down:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller:
                                      buttonIrCodeControllers['channelDown'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.volume_up_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Volume Up:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller:
                                      buttonIrCodeControllers['volumeUp'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.volume_down_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Volume Down:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller:
                                      buttonIrCodeControllers['volumeDown'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.menu_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Menu:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['menu'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.check),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("OK:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['okay'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.chevron_left),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Move Left:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller:
                                      buttonIrCodeControllers['moveLeft'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.keyboard_arrow_right_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Move Right:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller:
                                      buttonIrCodeControllers['moveRight'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.keyboard_arrow_up_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Move Up:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['moveUp'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.keyboard_arrow_down_rounded),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Move Down:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller:
                                      buttonIrCodeControllers['moveDown'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("0", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Zero:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['zero'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("1", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("One:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['one'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("2", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Two:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['two'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("3", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Three:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['three'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("4", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Four:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['four'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("5", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Five:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['five'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("6", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Six:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['six'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("7", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Seven:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['seven'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("8", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Eight:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['eight'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("9", style: TextStyle(fontSize: 20)),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Nine:"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: buttonIrCodeControllers['nine'],
                                  decoration: const InputDecoration(
                                    hintText: hintTextIrCodes,
                                  ),
                                  validator: HexValidator.validate,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          child: const Text('Add new'),
                          onPressed: () async {
                            await addNewTVModel();
                          }),
                      ElevatedButton(
                          child: const Text('Save changes'),
                          onPressed: () async {
                            await saveChangesToTVModel(selectedTVModel);
                          }),
                      ElevatedButton(
                        onPressed: () async {
                          await removeTVModel(selectedTVModel);
                        },
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                ])));
  }

  void initMantaTvModel() {
    mantaTvModel.name = 'Manta';
    mantaTvModel.zero.setIrCode(0xFE00FF);
    mantaTvModel.one.setIrCode(0xFE807F);
    mantaTvModel.two.setIrCode(0xFE40BF);
    mantaTvModel.three.setIrCode(0xFEC03F);
    mantaTvModel.four.setIrCode(0xFE20DF);
    mantaTvModel.five.setIrCode(0xFEA05F);
    mantaTvModel.six.setIrCode(0xFE609F);
    mantaTvModel.seven.setIrCode(0xFEE01F);
    mantaTvModel.eight.setIrCode(0xFE10EF);
    mantaTvModel.nine.setIrCode(0xFE906F);
    mantaTvModel.power.setIrCode(0xFEA857);
    mantaTvModel.mute.setIrCode(0xFE6897);
    mantaTvModel.channelUp.setIrCode(0xFE9867);
    mantaTvModel.channelDown.setIrCode(0xFE18E7);
    mantaTvModel.volumeUp.setIrCode(0xFED827);
    mantaTvModel.volumeDown.setIrCode(0xFE58A7);
    mantaTvModel.menu.setIrCode(0xFE8877);
    mantaTvModel.okay.setIrCode(0xFE08F7);
    mantaTvModel.moveUp.setIrCode(0xFE30CF);
    mantaTvModel.moveDown.setIrCode(0xFEB04F);
    mantaTvModel.moveLeft.setIrCode(0xFEF00F);
    mantaTvModel.moveRight.setIrCode(0xFE708F);
  }

  void updateFormTextFields() {
    nameController.text =
        (selectedTVModel == emptyTvModel) ? '' : selectedTVModel.name;
    buttonIrCodeControllers['zero']?.text =
        selectedTVModel.zero.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['one']?.text =
        selectedTVModel.one.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['two']?.text =
        selectedTVModel.two.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['three']?.text =
        selectedTVModel.three.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['four']?.text =
        selectedTVModel.four.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['five']?.text =
        selectedTVModel.five.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['six']?.text =
        selectedTVModel.six.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['seven']?.text =
        selectedTVModel.seven.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['eight']?.text =
        selectedTVModel.eight.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['nine']?.text =
        selectedTVModel.nine.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['power']?.text =
        selectedTVModel.power.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['mute']?.text =
        selectedTVModel.mute.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['channelUp']?.text =
        selectedTVModel.channelUp.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['channelDown']?.text =
        selectedTVModel.channelDown.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['volumeUp']?.text =
        selectedTVModel.volumeUp.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['volumeDown']?.text =
        selectedTVModel.volumeDown.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['menu']?.text =
        selectedTVModel.menu.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['okay']?.text =
        selectedTVModel.okay.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['moveUp']?.text =
        selectedTVModel.moveUp.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['moveDown']?.text =
        selectedTVModel.moveDown.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['moveLeft']?.text =
        selectedTVModel.moveLeft.getIrCode().toRadixString(16).toUpperCase();
    buttonIrCodeControllers['moveRight']?.text =
        selectedTVModel.moveRight.getIrCode().toRadixString(16).toUpperCase();
  }

  void setTvModelIrCodes(TVModel tvModel) {
    const String defaultIrCode = 'fff';
    tvModel.zero.setIrCode(int.parse(
        buttonIrCodeControllers['zero']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.one.setIrCode(int.parse(
        buttonIrCodeControllers['one']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.two.setIrCode(int.parse(
        buttonIrCodeControllers['two']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.three.setIrCode(int.parse(
        buttonIrCodeControllers['three']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.four.setIrCode(int.parse(
        buttonIrCodeControllers['four']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.five.setIrCode(int.parse(
        buttonIrCodeControllers['five']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.six.setIrCode(int.parse(
        buttonIrCodeControllers['six']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.seven.setIrCode(int.parse(
        buttonIrCodeControllers['seven']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.eight.setIrCode(int.parse(
        buttonIrCodeControllers['eight']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.nine.setIrCode(int.parse(
        buttonIrCodeControllers['nine']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.power.setIrCode(int.parse(
        buttonIrCodeControllers['power']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.mute.setIrCode(int.parse(
        buttonIrCodeControllers['mute']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.channelUp.setIrCode(int.parse(
        buttonIrCodeControllers['channelUp']?.text.toLowerCase() ??
            defaultIrCode,
        radix: 16));
    tvModel.channelDown.setIrCode(int.parse(
        buttonIrCodeControllers['channelDown']?.text.toLowerCase() ??
            defaultIrCode,
        radix: 16));
    tvModel.volumeUp.setIrCode(int.parse(
        buttonIrCodeControllers['volumeUp']?.text.toLowerCase() ??
            defaultIrCode,
        radix: 16));
    tvModel.volumeDown.setIrCode(int.parse(
        buttonIrCodeControllers['volumeDown']?.text.toLowerCase() ??
            defaultIrCode,
        radix: 16));
    tvModel.menu.setIrCode(int.parse(
        buttonIrCodeControllers['menu']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.okay.setIrCode(int.parse(
        buttonIrCodeControllers['okay']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.moveUp.setIrCode(int.parse(
        buttonIrCodeControllers['moveUp']?.text.toLowerCase() ?? defaultIrCode,
        radix: 16));
    tvModel.moveDown.setIrCode(int.parse(
        buttonIrCodeControllers['moveDown']?.text.toLowerCase() ??
            defaultIrCode,
        radix: 16));
    tvModel.moveLeft.setIrCode(int.parse(
        buttonIrCodeControllers['moveLeft']?.text.toLowerCase() ??
            defaultIrCode,
        radix: 16));
    tvModel.moveRight.setIrCode(int.parse(
        buttonIrCodeControllers['moveRight']?.text.toLowerCase() ??
            defaultIrCode,
        radix: 16));
  }

  void showNewTvModelAddedMessage() {
    Fluttertoast.showToast(
      msg: 'New TV model added succesfully.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showTvModelAlreadyExistsMessage() {
    Fluttertoast.showToast(
      msg: 'TV model with this name already exists!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showTvModelRemovedMessage() {
    Fluttertoast.showToast(
      msg: 'TV model removed succesfully.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.yellow,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showTvModelNotExistsMessage() {
    Fluttertoast.showToast(
      msg: 'TV model with this name doesn\'t exist!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showCannotDeleteDefaultMessage() {
    Fluttertoast.showToast(
      msg: 'You can\'t remove default model!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showCannotChangeDefaultMessage() {
    Fluttertoast.showToast(
      msg: 'You can\'t change default model!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showUseAddNewButtonMessage() {
    Fluttertoast.showToast(
      msg:
          'You\'ve changed name of the model. If you want to make new one, press \'Add new\'',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showTvModelSuccessfullyChangedMessage() {
    Fluttertoast.showToast(
      msg: 'Chnages on TV model saved successfully.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
