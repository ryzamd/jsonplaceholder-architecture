class KeycodeConstants {
  // Common scanner button keycodes
  static const int scannerKeyCode = 293; // Default hardware scanner trigger key
  static const int enterKeyCode = 13;    // Enter key
  static const int f1KeyCode = 112;      // F1 key (sometimes used for scanning)
  static const int f2KeyCode = 113;      // F2 key
  static const int f3KeyCode = 114;      // F3 key
  
  // List of all scanner-related keycodes
  static const List<int> scannerKeyCodes = [
    scannerKeyCode,
    enterKeyCode,
    f1KeyCode,
    f2KeyCode,
    f3KeyCode,
  ];
}