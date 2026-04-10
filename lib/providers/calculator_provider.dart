import 'package:flutter/material.dart';

class CalculatorProvider with ChangeNotifier {
  String _displayText = '0';
  String _equation = '';
  
  double? _firstOperand;
  String? _operator;
  bool _shouldResetDisplay = false;
  bool _isResult = false;

  String get displayText => _displayText;
  String get equation => _equation;

  void appendNumber(String num) {
    if (_isResult) {
      _displayText = num;
      _equation = '';
      _firstOperand = null;
      _operator = null;
      _isResult = false;
      _shouldResetDisplay = false;
    } else if (_shouldResetDisplay) {
      _displayText = num;
      _shouldResetDisplay = false;
    } else {
      if (_displayText == '0' && num != '.') {
        _displayText = num;
      } else {
        if (num == '.' && _displayText.contains('.')) return;
        _displayText += num;
      }
    }
    notifyListeners();
  }

  void setOperator(String op) {
    if (_isResult) {
      _equation = '$_displayText $op';
      _firstOperand = double.tryParse(_displayText);
      _operator = op;
      _isResult = false;
      _shouldResetDisplay = true;
    } else if (_operator != null && !_shouldResetDisplay) {
      double secondOperand = double.tryParse(_displayText) ?? 0;
      double result = _calculate(_firstOperand!, _operator!, secondOperand);
      
      _equation += ' ${_formatResult(secondOperand)} $op';
      _displayText = _formatResult(result);
      _firstOperand = result;
      _operator = op;
      _shouldResetDisplay = true;
    } else {
      _firstOperand = double.tryParse(_displayText);
      _operator = op;
      if (_equation.isEmpty) {
        _equation = '${_formatResult(_firstOperand ?? 0)} $op';
      } else {
        _equation = _equation.substring(0, _equation.length - 1) + op;
      }
      _shouldResetDisplay = true;
    }
    notifyListeners();
  }

  void calculateResult() {
    if (_firstOperand == null || _operator == null || _isResult) return;
    
    double secondOperand = double.tryParse(_displayText) ?? 0;
    _equation += ' ${_formatResult(secondOperand)} =';
    
    double result = _calculate(_firstOperand!, _operator!, secondOperand);

    _displayText = _formatResult(result);
    _isResult = true;
    _shouldResetDisplay = true;
    notifyListeners();
  }

  double _calculate(double a, String op, double b) {
    switch (op) {
      case '+': return a + b;
      case '-': return a - b;
      case 'x': 
      case '*': return a * b;
      case '/': return b == 0 ? double.nan : a / b;
      default: return b;
    }
  }

  void clear() {
    _displayText = '0';
    _equation = '';
    _firstOperand = null;
    _operator = null;
    _shouldResetDisplay = false;
    _isResult = false;
    notifyListeners();
  }

  void delete() {
    if (_shouldResetDisplay || _isResult) return;
    
    if (_displayText.length > 1) {
      _displayText = _displayText.substring(0, _displayText.length - 1);
    } else {
      _displayText = '0';
    }
    notifyListeners();
  }

  String _formatResult(double result) {
    if (result.isNaN) return 'Error';
    if (result == result.toInt()) {
      return result.toInt().toString();
    }
    String res = result.toStringAsFixed(6);
    return res.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }
}
