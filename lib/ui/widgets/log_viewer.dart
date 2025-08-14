import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LogViewer extends StatelessWidget {
  final List<String> logs;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const LogViewer({
    super.key,
    required this.logs,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.scroll(),
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Логи',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (onRefresh != null)
                  IconButton(
                    onPressed: isLoading ? null : onRefresh,
                    icon: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            PhosphorIcons.arrowClockwise(),
                            size: 16,
                          ),
                    tooltip: 'Обновить',
                  ),
              ],
            ),
          ),
          
          // Разделитель
          Container(
            height: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
          
          // Содержимое логов
          Expanded(
            child: logs.isEmpty
                ? _buildEmptyState(context)
                : _buildLogsList(context),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.scroll(),
            size: 48,
            color: Theme.of(context).hintColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Логи отсутствуют',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Логи появятся здесь после запуска бота',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogsList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final isError = log.toLowerCase().contains('error') || 
                       log.toLowerCase().contains('ошибка');
        final isWarning = log.toLowerCase().contains('warning') || 
                         log.toLowerCase().contains('предупреждение');
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isError
                  ? Theme.of(context).colorScheme.error.withOpacity(0.4)
                  : isWarning
                      ? Colors.orange.withOpacity(0.4)
                      : Theme.of(context).colorScheme.outline,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isError
                      ? Theme.of(context).colorScheme.error
                      : isWarning
                          ? Colors.orange
                          : Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  log,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: isError
                        ? Theme.of(context).colorScheme.error
                        : isWarning
                            ? Colors.orange
                            : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 300.ms, delay: (index * 50).ms).slideX(begin: 0.3);
      },
    );
  }
}

class LogEntry extends StatelessWidget {
  final String message;
  final DateTime timestamp;
  final LogLevel level;

  const LogEntry({
    super.key,
    required this.message,
    required this.timestamp,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getLevelColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _getLevelColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              _getLevelIcon(),
              size: 12,
              color: _getLevelColor(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getLevelColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor() {
    switch (level) {
      case LogLevel.error:
        return Colors.red[600]!;
      case LogLevel.warning:
        return Colors.orange[600]!;
      case LogLevel.info:
        return Colors.blue[600]!;
      case LogLevel.success:
        return Colors.green[600]!;
    }
  }

  IconData _getLevelIcon() {
    switch (level) {
      case LogLevel.error:
        return PhosphorIcons.xCircle();
      case LogLevel.warning:
        return PhosphorIcons.warning();
      case LogLevel.info:
        return PhosphorIcons.info();
      case LogLevel.success:
        return PhosphorIcons.checkCircle();
    }
  }

  String _formatTimestamp() {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }
}

enum LogLevel {
  error,
  warning,
  info,
  success,
}
