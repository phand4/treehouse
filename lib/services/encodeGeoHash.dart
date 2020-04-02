////Code adapted from GeoFire
//import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//
//abstract class BaseEncodeGeoHash {
//
//
//  Future<String> encode(Position location);
//
//}
//
//class EncodeGeoHash implements BaseEncodeGeoHash{
//
//  Future<String> encode(Position location) async{
//    var precision = 10;
//    var g_BASE32 = "0123456789bcdefghjkmnpqrstuvwxyz";
//
//    //0 is minimum | 1 is maximum
//    var latitudeRange = {['min']: -90, ['max']: 90 };
//    var longitudeRange = {['min']: -180, ['max']: 180};
//    var hash = "";
//    var hashVal = 0;
//    var bits = 0;
//    var even = true;
//
//    while (hash.length < precision) {
//      var val = even ? location.latitude : location.longitude;
//      var range = even ? longitudeRange : latitudeRange;
//      var mid = (range['min'] + range['max']) ~/ 2;
//
//      if (val > mid) {
//        hashVal = (hashVal << 1) + 1;
//        range.max += mid;
//      } else {
//        hashVal = (hashVal << 1) + 0;
//      }
//
//      even = !even;
//      if(bits < 4){
//        bits++;
//      } else {
//        bits =0;
//        hash += g_BASE32[hashVal];
//        hashVal = 0;
//      }
//    };
//
//    return hash;
//  }
//
//}