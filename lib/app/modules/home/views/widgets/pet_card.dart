import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pets_store/app/data/models/pet_model.dart';

class PetCard extends StatefulWidget {
  final PetModel pet;
  final VoidCallback? onTap;

  const PetCard({super.key, required this.pet, this.onTap});

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final photoUrls = widget.pet.photoUrls;
    final hasPhotos = photoUrls.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: colors.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.primary.withAlpha(50), width: 2),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  Container(
                    color: colors.primaryContainer,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: hasPhotos
                          ? PageView.builder(
                              controller: _pageController,
                              itemCount: photoUrls.length,
                              onPageChanged: (index) => setState(() {
                                _currentIndex = index;
                              }),
                              itemBuilder: (context, index) {
                                final url = photoUrls[index];
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  switchInCurve: Curves.easeOut,
                                  switchOutCurve: Curves.easeIn,
                                  child: Image.network(
                                    url,
                                    key: ValueKey(url),
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                    colors.primary,
                                                  ),
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, _, __) =>
                                        _ImagePlaceholder(colors: colors),
                                  ),
                                );
                              },
                            )
                          : _ImagePlaceholder(colors: colors),
                    ),
                  ),
                  // Minimal indicator dots
                  if (hasPhotos)
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(photoUrls.length, (i) {
                                final isActive = i == _currentIndex;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 240),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  height: 6,
                                  width: isActive ? 14 : 6,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? colors.primary
                                        : Colors.white.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          widget.pet.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(status: widget.pet.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.pet.category.name.isNotEmpty
                        ? widget.pet.category.name
                        : 'Unknown category',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Tags chips
                  if (widget.pet.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.pet.tags.map((t) {
                        return Chip(
                          label: Text(
                            t.name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                          backgroundColor: colors.primary.withValues(
                            alpha: 0.08,
                          ),
                          side: BorderSide(
                            color: colors.primary.withValues(alpha: 0.14),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
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

class _ImagePlaceholder extends StatelessWidget {
  final ColorScheme colors;
  const _ImagePlaceholder({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.primaryContainer,
      child: Center(
        child: Icon(
          Icons.pets,
          size: 48,
          color: colors.primary.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Color bg;
    Color fg;
    switch (status.toLowerCase()) {
      case 'available':
        bg = Colors.green.withValues(alpha: 0.12);
        fg = Colors.green;
        break;
      case 'pending':
        bg = colors.secondary.withValues(alpha: 0.12);
        fg = colors.secondary;
        break;
      case 'sold':
        bg = Colors.red.withValues(alpha: 0.12);
        fg = Colors.red;
        break;
      default:
        bg = Colors.grey.withValues(alpha: 0.14);
        fg = Colors.grey[800] ?? Colors.black54;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        GetUtils.capitalize(status) as String,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
