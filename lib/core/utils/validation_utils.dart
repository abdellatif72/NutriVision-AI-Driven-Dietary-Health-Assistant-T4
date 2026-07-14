abstract final class ValidationUtils {
  /// Computes the Levenshtein distance between two strings.
  static int getLevenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = [
          v1[j] + 1,
          v0[j + 1] + 1,
          v0[j] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
      v0 = List<int>.from(v1);
    }
    return v0[t.length];
  }

  /// Suggests a corrected email address if there are common domain typos
  /// or a missing dot before the TLD (e.g., com, net, org).
  /// Returns null if no correction is suggested.
  static String? suggestEmailCorrection(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return null;

    final parts = trimmed.split('@');
    if (parts.length != 2) return null;

    final localPart = parts[0];
    var domainPart = parts[1].toLowerCase();

    if (localPart.isEmpty || domainPart.isEmpty) return null;

    bool modified = false;

    // 1. Handle missing dot before TLD
    if (!domainPart.contains('.')) {
      final tlds = ['com', 'net', 'org', 'edu', 'gov', 'co', 'io'];
      for (final tld in tlds) {
        if (domainPart.endsWith(tld) && domainPart.length > tld.length) {
          domainPart = '${domainPart.substring(0, domainPart.length - tld.length)}.$tld';
          modified = true;
          break;
        }
      }
    }

    // List of popular target domains for typo correction
    final popularDomains = ['gmail.com', 'outlook.com', 'yahoo.com', 'hotmail.com'];

    // List of other known valid domains to avoid incorrect corrections (e.g., mail.com -> gmail.com)
    final knownValidDomains = {
      'gmail.com',
      'outlook.com',
      'yahoo.com',
      'hotmail.com',
      'icloud.com',
      'live.com',
      'msn.com',
      'mail.com',
      'aol.com',
      'protonmail.com',
      'proton.me',
      'yandex.com',
      'zoho.com',
      'gmx.com'
    };

    if (!knownValidDomains.contains(domainPart)) {
      String? bestMatch;
      int minDistance = 999;

      for (final popular in popularDomains) {
        final dist = getLevenshteinDistance(domainPart, popular);
        if (dist < minDistance) {
          minDistance = dist;
          bestMatch = popular;
        }
      }

      // If we found a close match (distance 1 or 2), we suggest it.
      if (minDistance > 0 && minDistance <= 2 && bestMatch != null) {
        domainPart = bestMatch;
        modified = true;
      }
    }

    if (modified) {
      return '$localPart@$domainPart';
    }

    return null;
  }

  /// Validates email structural correctness.
  /// Returns null if valid, or a localized Arabic error message.
  static String? validateEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    
    // Simple check for presence of @
    if (!trimmed.contains('@')) {
      return 'يرجى إدخال بريد إلكتروني صحيح يحتوي على @';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }

    return null;
  }

  /// Validates password based on:
  /// - At least 6 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one number
  /// - At least one special character
  /// Returns null if valid, or a localized Arabic error message.
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }

    final hasMinLength = password.length >= 6;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>\-_+=~`\[\]\\/]'));

    final missing = <String>[];
    if (!hasUppercase) missing.add('حرف كبير');
    if (!hasLowercase) missing.add('حرف صغير');
    if (!hasDigits) missing.add('رقم');
    if (!hasSpecialCharacters) missing.add('رمز خاص');

    if (!hasMinLength || missing.isNotEmpty) {
      String error = '';
      if (!hasMinLength) {
        error = 'كلمة المرور يجب أن تتكون من 6 أحرف على الأقل';
        if (missing.isNotEmpty) {
          String missingText;
          if (missing.length == 1) {
            missingText = missing[0];
          } else {
            missingText = '${missing.sublist(0, missing.length - 1).join("، ")}، و${missing.last}';
          }
          error += ' وتحتوي على $missingText';
        }
      } else {
        String missingText;
        if (missing.length == 1) {
          missingText = missing[0];
        } else {
          missingText = '${missing.sublist(0, missing.length - 1).join("، ")}، و${missing.last}';
        }
        error = 'كلمة المرور يجب أن تحتوي على $missingText';
      }
      return error;
    }

    return null;
  }
}
