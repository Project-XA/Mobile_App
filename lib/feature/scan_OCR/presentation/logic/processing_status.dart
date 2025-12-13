enum ProcessingStatus { 
  idle, 
  processing, 
  completed, 
  invalidCard, 
  error 
}

extension ProcessingStatusExtension on ProcessingStatus {
  String get displayText {
    switch (this) {
      case ProcessingStatus.idle:
        return 'Ready';
      case ProcessingStatus.processing:
        return 'Processing...';
      case ProcessingStatus.completed:
        return 'Completed';
      case ProcessingStatus.invalidCard:
        return 'Invalid Card';
      case ProcessingStatus.error:
        return 'Processing Error';
    }
  }

  bool get isProcessing => this == ProcessingStatus.processing;
  bool get isCompleted => this == ProcessingStatus.completed;
  bool get hasError => this == ProcessingStatus.error;
}