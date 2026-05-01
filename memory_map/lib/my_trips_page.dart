import 'dart:async';
import 'package:flutter/material.dart';
import 'profile_page.dart';

class MyTrips extends StatelessWidget {
  const MyTrips({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Search Bar + Sort & Filter Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchBar(
                    hintText: 'Search trips...',
                    leading: const Icon(Icons.search),
                    padding: const WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  context,
                  icon: Icons.sort,
                  onPressed: () => _showSortSheet(context),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  context,
                  icon: Icons.filter_list,
                  onPressed: () => _showFilterSheet(context),
                ),
              ],
            ),
          ),

          // Scrollable Grid of Trips
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return _buildTripCard(context, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Country Name'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Rating'),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context) {
    double ratingValue = 4.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Configuration',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Destination', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter country or city',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${ratingValue.toStringAsFixed(1)} ★', 
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: ratingValue,
                    min: 1.0,
                    max: 5.0,
                    divisions: 4,
                    label: ratingValue.toString(),
                    onChanged: (value) {
                      setModalState(() {
                        ratingValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Select Dates'),
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Reset All'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTripPreview(BuildContext context, Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) => _TripPreviewDialog(trip: trip),
    );
  }

  Widget _buildTripCard(BuildContext context, int index) {
    final List<Map<String, dynamic>> dummyTrips = [
      {
        'title': 'Trip with friends', 
        'country': 'France', 'city': 'Paris', 
        'date': '01/05/26 - 07/05/26', 'travelers': '2', 'rating': '4.8', 
        'images': [
          'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=400',
          'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?q=80&w=400',
          'https://images.unsplash.com/photo-1549144511-f099e773c147?q=80&w=400',
        ]
      },
      {
        'title': 'Solo Adventure', 
        'country': 'Japan', 'city': 'Tokyo', 
        'date': '10/06/26 - 20/06/26', 'travelers': '1', 'rating': '4.9', 
        'images': [
          'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?q=80&w=400',
          'https://images.unsplash.com/photo-1503899036084-c55cdd92da26?q=80&w=400',
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=400',
        ]
      },
      {
        'title': 'Family Vacation', 
        'country': 'Italy', 'city': 'Rome', 
        'date': '05/07/26 - 15/07/26', 'travelers': '4', 'rating': '4.7', 
        'images': [
          'https://images.unsplash.com/photo-1552832230-c0197dd311b5?q=80&w=400',
          'https://images.unsplash.com/photo-1529260839382-3fea6afb6177?q=80&w=400',
          'https://images.unsplash.com/photo-1531572753322-ad063cecc140?q=80&w=400',
        ]
      },
      {
        'title': 'Romantic Getaway', 
        'country': 'Spain', 'city': 'Barcelona', 
        'date': '01/08/26 - 10/08/26', 'travelers': '2', 'rating': '4.6', 
        'images': [
          'https://images.unsplash.com/photo-1511527661048-7fe73d85e9a4?q=80&w=400',
          'https://images.unsplash.com/photo-1583997051654-820ca143360b?q=80&w=400',
          'https://images.unsplash.com/photo-1539186607619-df476afe6ff1?q=80&w=400',
        ]
      },
      {
        'title': 'Business Trip', 
        'country': 'USA', 'city': 'New York', 
        'date': '15/09/26 - 25/09/26', 'travelers': '2', 'rating': '4.5', 
        'images': [
          'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?q=80&w=400',
          'https://images.unsplash.com/photo-1485871922621-68fe41e430bd?q=80&w=400',
          'https://images.unsplash.com/photo-1534430480872-3498386e7a56?q=80&w=400',
        ]
      },
      {
        'title': 'City Break', 
        'country': 'UK', 'city': 'London', 
        'date': '05/10/26 - 12/10/26', 'travelers': '3', 'rating': '4.7', 
        'images': [
          'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?q=80&w=400',
          'https://images.unsplash.com/photo-1526129318478-62ed807ebdf9?q=80&w=400',
          'https://images.unsplash.com/photo-1505761671935-60b3a7427bad?q=80&w=400',
        ]
      },
      {
        'title': 'Coastal Escape', 
        'country': 'Portugal', 'city': 'Porto', 
        'date': '01/11/26 - 06/11/26', 'travelers': '2', 'rating': '4.8', 
        'images': [
          'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?q=80&w=400',
          'https://images.unsplash.com/photo-1520114878144-6123749968dd?q=80&w=400',
          'https://images.unsplash.com/photo-1534346589587-9b51347da395?q=80&w=400',
        ]
      },
      {
        'title': 'Northern Lights', 
        'country': 'Iceland', 'city': 'Reykjavik', 
        'date': '20/12/26 - 30/12/26', 'travelers': '2', 'rating': '4.9', 
        'images': [
          'https://images.unsplash.com/photo-1504109586057-7a2ae83d1338?q=80&w=400',
          'https://images.unsplash.com/photo-1529963183134-61a90db47eaf?q=80&w=400',
          'https://images.unsplash.com/photo-1476610182048-b716b8518aae?q=80&w=400',
        ]
      },
    ];

    final trip = dummyTrips[index % dummyTrips.length];

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showTripPreview(context, trip),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(trip['images'][0]!, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.8)
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(2, 2))],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${trip['country']}, ${trip['city']}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 13),
                              const SizedBox(width: 2),
                              Text(
                                trip['rating']!,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(trip['date']!, style: const TextStyle(color: Colors.white70, fontSize: 9)),
                          Row(
                            children: [
                              const Icon(Icons.people, color: Colors.white70, size: 10),
                              const SizedBox(width: 4),
                              Text(trip['travelers']!, style: const TextStyle(color: Colors.white70, fontSize: 9)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripPreviewDialog extends StatefulWidget {
  final Map<String, dynamic> trip;
  const _TripPreviewDialog({required this.trip});

  @override
  State<_TripPreviewDialog> createState() => _TripPreviewDialogState();
}

class _TripPreviewDialogState extends State<_TripPreviewDialog> {
  late List<String> _images;
  int _currentImageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _images = List<String>.from(widget.trip['images']);
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _images.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Animated Image
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Image.network(
                  _images[_currentImageIndex],
                  key: ValueKey<int>(_currentImageIndex),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
              // Close Button
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top: Title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.trip['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white70, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.trip['country']}, ${widget.trip['city']}',
                              style: const TextStyle(color: Colors.white70, fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Bottom: Info + Button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_month, color: Colors.white70, size: 16),
                                const SizedBox(width: 6),
                                Text(widget.trip['date']!, style: const TextStyle(color: Colors.white, fontSize: 14)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(widget.trip['rating']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.people, color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.trip['travelers']!} Travelers',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const ProfilePage())
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('SEE DETAILS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
