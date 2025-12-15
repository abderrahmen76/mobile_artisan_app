import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

/// High-level wrapper around Supabase for auth & basic data calls.
///
/// Database layout you should create in Supabase (SQL):
///
/// ```sql
/// create table public.client_profiles (
///   id uuid primary key references auth.users (id) on delete cascade,
///   first_name text,
///   last_name  text,
///   phone      text,
///   created_at timestamptz default now()
/// );
///
/// create table public.artisan_profiles (
///   id uuid primary key references auth.users (id) on delete cascade,
///   full_name  text,
///   profession text,
///   phone      text,
///   location   text,
///   skills     text,
///   created_at timestamptz default now()
/// );
/// ```
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  SupabaseClient get client => _client;

  /// Upload a profile image to the `profile-images` bucket and return its public URL.
  Future<String?> uploadProfileImage({
    required File file,
    required String userId,
  }) async {
    final ext = p.extension(file.path);
    final filePath = 'avatars/$userId$ext';

    await _client.storage.from('profile-images').upload(
          filePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    final publicUrl =
        _client.storage.from('profile-images').getPublicUrl(filePath);
    return publicUrl;
  }

  /// Sign up a new client using email & password and create a profile row.
  Future<AuthResponse> signUpClient({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'role': 'client',
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      },
    );

    final user = response.user;
    if (user != null) {
      await _client.from('client_profiles').insert({
        'id': user.id,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      });
    }

    return response;
  }

  /// Sign up a new artisan and create a profile row.
  Future<AuthResponse> signUpArtisan({
    required String email,
    required String password,
    required String fullName,
    required String profession,
    required String phone,
    required String location,
    required String skills,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'role': 'artisan',
        'full_name': fullName,
        'profession': profession,
        'phone': phone,
        'location': location,
      },
    );

    final user = response.user;
    if (user != null) {
      await _client.from('artisan_profiles').insert({
        'id': user.id,
        'full_name': fullName,
        'profession': profession,
        'phone': phone,
        'location': location,
        'skills': skills,
      });
    }

    return response;
  }

  /// Email/password sign-in.
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
