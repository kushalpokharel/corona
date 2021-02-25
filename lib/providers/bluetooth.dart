import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart' hide BluetoothDevice;
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid/helpers/user.dart';



class BlueToothProvider with ChangeNotifier {
  FirebaseAuth _auth= FirebaseAuth.instance;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  bool isOn;
  String _data = 'Nobody found yet!';
  bool _scanning = false;
  FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();
  Firestore _firestore = Firestore.instance;


  String get data => _data;

  BlueToothProvider.initialize(){

    searchForDevices();
  }

  void turnOn()async{
    isOn = await flutterBlue.isOn;
    notifyListeners();
  }

  void updateDb(BluetoothDevice device, address) async{
    // print("updatedb");
    // final list = await _firestore.collection("infected").document(address).get();
    // print(list["closeContacts"]);
    // if (list["closeContacts"].contains(device.address))
    // {
    //   return;
    // }
    // list["closeContacts"].add(device.address);
    // print(list["closeContacts"]);
    // await _firestore.collection("infected").document(address).setData({"closeContacts":list["closeContacts"]});
    final ref = await _firestore
        .collection('infected');


    ref.document(address).updateData({'closeContacts':FieldValue.arrayUnion([device.address])});

  }

    Future<String> getadd() async{
      final _user = await _auth.currentUser();
      if(_user==null)
        return "";
      final _userServicse = await UserServices();
      final _userModel = await _userServicse.getUserById(_user.uid);
      if(_userModel==null)
        return "";
      final add = _userModel.bluetoothAddress;
      return add;
    }

  Future<void> searchForDevices() async{

    isOn = await flutterBlue.isOn;
    notifyListeners();
    if(!isOn){
      return;
    }else{
      await _bluetooth.startScan(pairedDevices: false);

      _bluetooth.devices.toList().then((v){
        print("number of devices: ${ v.length}");
      });
      _bluetooth.devices.listen((device) async{
          if(device != null){
            _data = "";
            String _bluetoothAdd = await getadd();
            if(_bluetoothAdd!="")
              updateDb(device,_bluetoothAdd);
          }
          _data += device.name+' (${device.address})\n';
          notifyListeners();
      });
      _bluetooth.scanStopped.listen ((device) {

            _scanning = false;
            // _data += 'scan stopped\n';
            _bluetooth.startScan(pairedDevices: false);
            _scanning = true;
            notifyListeners();
          });
        }
      }
    }

