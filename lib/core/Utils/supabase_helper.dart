import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SupabaseHelper {
  static const String supabaseUrl = 'https://hmnzovknjzzuyudpyrnu.supabase.co';
  static const String supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhtbnpvdmtuanp6dXl1ZHB5cm51Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3OTU1OTk1NCwiZXhwIjoyMDk1MTM1OTU0fQ.OjyvqvyuSlSPGYTnCR91IqDKrs5BuDxo265TlOPPVFQ';
  static const String bucketName = 'images';

  static Future<String> uploadImage(File imageFile) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = '$bucketName/$fileName';

    final uri = Uri.parse('$supabaseUrl/storage/v1/object/$path');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $supabaseKey',
        'Content-Type': 'image/jpeg',
      },
      body: await imageFile.readAsBytes(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final publicUrl = '$supabaseUrl/storage/v1/object/public/$path';
      print('✅ رُفعت الصورة: $publicUrl');
      return publicUrl;
    } else {
      print('❌ فشل الرفع: ${response.body}');
      throw Exception('فشل رفع الصورة: ${response.body}');
    }
  }

  /// يحذف صورة من Supabase Storage بالاعتماد على رابطها العام (publicUrl)
  /// لا يرمي Exception عند الفشل حتى ما توقف عملية رفع الصورة الجديدة
  static Future<void> deleteImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty) return;
      const marker = '/storage/v1/object/public/';
      final index = imageUrl.indexOf(marker);
      if (index == -1) {
        print('⚠️ رابط الصورة غير متوافق مع Supabase، تم تجاهل الحذف');
        return;
      }
      final path = imageUrl.substring(index + marker.length);
      final uri = Uri.parse('$supabaseUrl/storage/v1/object/$path');

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $supabaseKey',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ تم حذف الصورة القديمة: $path');
      } else {
        print('⚠️ فشل حذف الصورة القديمة: ${response.body}');
      }
    } catch (e) {
      print('⚠️ خطأ أثناء حذف الصورة القديمة: $e');
    }
  }
}
