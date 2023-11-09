import 'package:bt2ir/tv_model.dart';
import 'package:flutter/material.dart';
import 'ble_connection.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  static final _bleService = BLEService();
  bool isSending = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Center(child: Text('Main buttons')),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () async {
                      if (!isSending) {
                        isSending = true;
                        await _bleService.sendButtonIdToDevice(
                            TVModelHandle.selectedTVModel.mute.getId());
                        await _bleService.sendIrCodeToDevice(
                            TVModelHandle.selectedTVModel.mute.getIrCode());
                        isSending = false;
                      }
                    },
                    child: const Icon(Icons.volume_off_rounded, size: 40),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15), // text color
                      ),
                      onPressed: () async {
                        if (!isSending) {
                          isSending = true;
                          await _bleService.sendButtonIdToDevice(
                              TVModelHandle.selectedTVModel.power.getId());
                          await _bleService.sendIrCodeToDevice(
                              TVModelHandle.selectedTVModel.power.getIrCode());
                          isSending = false;
                        }
                      },
                      child: const Icon(Icons.power_settings_new_rounded,
                          size: 40)),
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 45.0, vertical: 7.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () async {
                  if (!isSending) {
                    isSending = true;
                    await _bleService.sendButtonIdToDevice(
                        TVModelHandle.selectedTVModel.moveUp.getId());
                    await _bleService.sendIrCodeToDevice(
                        TVModelHandle.selectedTVModel.moveUp.getIrCode());
                    isSending = false;
                  }
                },
                child: const Icon(Icons.keyboard_arrow_up_rounded, size: 40),
              ),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () async {
                  if (!isSending) {
                    isSending = true;
                    await _bleService.sendButtonIdToDevice(
                        TVModelHandle.selectedTVModel.moveLeft.getId());
                    await _bleService.sendIrCodeToDevice(
                        TVModelHandle.selectedTVModel.moveLeft.getIrCode());
                    isSending = false;
                  }
                },
                child: const Icon(Icons.chevron_left_rounded, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () async {
                  if (!isSending) {
                    isSending = true;
                    await _bleService.sendButtonIdToDevice(
                        TVModelHandle.selectedTVModel.okay.getId());
                    await _bleService.sendIrCodeToDevice(
                        TVModelHandle.selectedTVModel.okay.getIrCode());
                    isSending = false;
                  }
                },
                child: const Center(
                  child: Text(
                    "OK",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 43),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () async {
                  if (!isSending) {
                    isSending = true;
                    await _bleService.sendButtonIdToDevice(
                        TVModelHandle.selectedTVModel.moveRight.getId());
                    await _bleService.sendIrCodeToDevice(
                        TVModelHandle.selectedTVModel.moveRight.getIrCode());
                    isSending = false;
                  }
                },
                child: const Icon(Icons.chevron_right_rounded, size: 40),
              ),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 45.0, vertical: 7.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () async {
                  if (!isSending) {
                    isSending = true;
                    await _bleService.sendButtonIdToDevice(
                        TVModelHandle.selectedTVModel.moveDown.getId());
                    await _bleService.sendIrCodeToDevice(
                        TVModelHandle.selectedTVModel.moveDown.getIrCode());
                    isSending = false;
                  }
                },
                child: const Icon(Icons.keyboard_arrow_down_rounded, size: 40),
              ),
            ),
          ]),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomPaint(
                        painter: BackgroundForVolumeAndChannel(),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: () async {
                            if (!isSending) {
                              isSending = true;
                              await _bleService.sendButtonIdToDevice(
                                  TVModelHandle.selectedTVModel.volumeUp
                                      .getId());
                              await _bleService.sendIrCodeToDevice(TVModelHandle
                                  .selectedTVModel.volumeUp
                                  .getIrCode());
                              isSending = false;
                            }
                          },
                          child: const Icon(Icons.volume_up_rounded, size: 40),
                        ),
                      ),
                      const Text("Volume"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: () async {
                          if (!isSending) {
                            isSending = true;
                            await _bleService.sendButtonIdToDevice(TVModelHandle
                                .selectedTVModel.volumeDown
                                .getId());
                            await _bleService.sendIrCodeToDevice(TVModelHandle
                                .selectedTVModel.volumeDown
                                .getIrCode());
                            isSending = false;
                          }
                        },
                        child: const Icon(Icons.volume_down_rounded, size: 40),
                      ),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: () async {
                          if (!isSending) {
                            isSending = true;
                            await _bleService.sendButtonIdToDevice(
                                TVModelHandle.selectedTVModel.menu.getId());
                            await _bleService.sendIrCodeToDevice(
                                TVModelHandle.selectedTVModel.menu.getIrCode());
                            isSending = false;
                          }
                        },
                        child: const Icon(Icons.menu_rounded, size: 40),
                      ),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomPaint(
                        painter: BackgroundForVolumeAndChannel(),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: () async {
                            if (!isSending) {
                              isSending = true;
                              await _bleService.sendButtonIdToDevice(
                                  TVModelHandle.selectedTVModel.channelUp
                                      .getId());
                              await _bleService.sendIrCodeToDevice(TVModelHandle
                                  .selectedTVModel.channelUp
                                  .getIrCode());
                              isSending = false;
                            }
                          },
                          child: const Icon(Icons.plus_one_rounded, size: 40),
                        ),
                      ),
                      const Text("Channel"),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: () async {
                          if (!isSending) {
                            isSending = true;
                            await _bleService.sendButtonIdToDevice(TVModelHandle
                                .selectedTVModel.channelDown
                                .getId());
                            await _bleService.sendIrCodeToDevice(TVModelHandle
                                .selectedTVModel.channelDown
                                .getIrCode());
                            isSending = false;
                          }
                        },
                        child: const Icon(Icons.exposure_minus_1_rounded,
                            size: 40),
                      ),
                    ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BackgroundForVolumeAndChannel extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    final RRect rrect = RRect.fromRectAndRadius(
        Rect.fromPoints(const Offset(0, 0), const Offset(70, 220)),
        const Radius.circular(42.0)); // Dostosuj zaokrąglenie narożników

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
