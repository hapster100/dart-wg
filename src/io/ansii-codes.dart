class ANSICodes {
  static const HOME = "\x1b[H";
  static const CLEAR = "\x1b[2J";
  static final RGBF = (int r, int g, int b) => "\x1b[38;2;${r};${g};${b}m";
  static final RGBB = (int r, int g, int b) => "\x1b[48;2;${r};${g};${b}m";
  static final CURMOVE = (int l, int c) => "\x1b[${l};${c}H";
  static const RESETALL = "\x1b[0m";
  static const CURHIDE = "\x1b[?25l";
  static const CURSHOW = "\x1b[?25h";
  static const HIDDEN_MOD = "\x1b[8m";
  static const BOLD = "\x1b[1m";
  static const BOLD_RESET = "\x1b[22m";
}
