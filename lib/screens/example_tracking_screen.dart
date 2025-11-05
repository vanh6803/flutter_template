import 'package:flutter/material.dart';
import '../core/widgets/base_widget.dart';
import '../core/utils/tracking_utils.dart';

/// Example screen showing how to use Firebase tracking
class ExampleTrackingScreen extends BaseStatefulWidget {
  const ExampleTrackingScreen({super.key});

  @override
  State<ExampleTrackingScreen> createState() => _ExampleTrackingScreenState();
}

class _ExampleTrackingScreenState extends BaseState<ExampleTrackingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedItem = '';

  @override
  String get screenName => 'Example Tracking';

  @override
  String get screenClass => 'ExampleTrackingScreen';

  @override
  void onInitSync() {
    // This runs immediately in initState (no context needed)
    // Good for initializing controllers, streams, etc.
  }

  @override
  void onReady() {
    // This runs after the first frame (context available)
    // Screen view is automatically tracked by BaseState

    // Track that user reached this example screen
    trackFeatureUsed('tracking_example_viewed');
  }

  void _performSearch() {
    final query = _searchController.text;
    if (query.isEmpty) return;

    // Simulate search results
    final resultCount = query.length % 10; // Mock result count

    // Track the search
    trackSearch(
      query,
      additionalParams: {
        'result_count': resultCount,
        'search_type': 'example_search',
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Search tracked: "$query" ($resultCount results)'),
      ),
    );
  }

  void _selectItem(String itemId, String itemName) {
    setState(() {
      _selectedItem = itemName;
    });

    // Track item selection
    trackItemSelect(
      itemId,
      itemName,
      category: 'demo_items',
      additionalParams: {'selection_method': 'tap'},
    );
  }

  void _simulateApiCall() async {
    final stopwatch = Stopwatch()..start();

    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      stopwatch.stop();

      // Track successful API call
      await TrackingUtils.trackApiCall(
        '/api/demo',
        'GET',
        200,
        stopwatch.elapsedMilliseconds,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('API call tracked successfully')),
        );
      }
    } catch (e) {
      stopwatch.stop();

      // Track API error
      await TrackingUtils.trackApiError('/api/demo', 'GET', 500, e.toString());

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('API error tracked')));
      }
    }
  }

  void _trackCustomEvent() {
    // Track a custom event with parameters
    trackCustomEvent('demo_interaction', {
      'interaction_type': 'custom_button',
      'user_action': 'experimental_feature',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Custom event tracked')));
  }

  void _simulateError() {
    try {
      throw Exception('Demo error for tracking');
    } catch (e) {
      // Track the error with context
      trackError(
        'demo_error',
        e.toString(),
        errorCode: 'DEMO001',
        additionalParams: {
          'error_context': 'user_triggered_demo',
          'user_action': 'simulate_error_button',
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error tracked successfully')),
      );
    }
  }

  void _trackFormSubmission() async {
    final formData = {
      'search_query': _searchController.text,
      'selected_item': _selectedItem,
    };

    // Track form submission
    await TrackingUtils.trackFormSubmission(
      'demo_form',
      true, // Assume successful
      additionalParams: {
        'field_count': formData.length,
        'has_search_query': _searchController.text.isNotEmpty,
        'has_selection': _selectedItem.isNotEmpty,
      },
    );

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form submission tracked')));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Tracking',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Enter search query...',
                        suffixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (_) => _performSearch(),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _performSearch,
                      child: const Text('Search & Track'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Item Selection Example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Item Selection Tracking',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Selected: $_selectedItem'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Apple', 'Banana', 'Cherry', 'Date']
                          .map(
                            (item) => ElevatedButton(
                              onPressed: () =>
                                  _selectItem(item.toLowerCase(), item),
                              child: Text(item),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Various Tracking Examples
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Other Tracking Examples',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: _simulateApiCall,
                          child: const Text('API Call'),
                        ),
                        ElevatedButton(
                          onPressed: _trackCustomEvent,
                          child: const Text('Custom Event'),
                        ),
                        ElevatedButton(
                          onPressed: _simulateError,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Simulate Error'),
                        ),
                        ElevatedButton(
                          onPressed: _trackFormSubmission,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Form Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      'All tracking events are automatically logged to Firebase Analytics and visible in debug console.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
