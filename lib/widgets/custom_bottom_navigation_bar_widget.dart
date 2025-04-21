import 'package:app_pd_cocimiento/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Modelo para los ítems de la navegación inferior.
class CustomBottomNavigationBarItem {
  final IconData icon;
  final String label;
  final Color color;

  const CustomBottomNavigationBarItem({
    required this.icon,
    required this.label,
    this.color = Colors.blue,
  });
}

class CustomBottomNavigationBarWidget extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CustomBottomNavigationBarItem> items;

  const CustomBottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBarWidget> createState() =>
      _CustomBottomNavigationBarWidgetState();
}

class _CustomBottomNavigationBarWidgetState extends State<CustomBottomNavigationBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _centerAnimation;
  late Animation<double> _widthAnimation;

  // Valor final (mínimo) de ancho del indicador (cuando termina la animación).
  final double finalIndicatorWidth = 4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant CustomBottomNavigationBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _startAnimation(oldWidget.currentIndex, widget.currentIndex);
    }
  }

  void _startAnimation(int oldIndex, int newIndex) {
    // Utilizamos LayoutBuilder en el build para conocer el ancho total y derivar el ancho de cada ítem.
    // Como no disponemos de esos valores aquí, usaremos un post-frame callback para obtenerlos.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final double totalWidth = box.size.width;
      final int itemCount = widget.items.length;
      final double itemWidth = totalWidth / itemCount;
      // El centro de un ítem se calcula:
      final double startCenter = oldIndex * itemWidth + itemWidth / 2;
      final double endCenter = newIndex * itemWidth + itemWidth / 2;

      // Creamos la animación del centro.
      _centerAnimation = Tween<double>(
        begin: startCenter,
        end: endCenter,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));

      // Anima el ancho: inicia en finalIndicatorWidth, expande hasta itemWidth/2 a la mitad y vuelve a finalIndicatorWidth.
      _widthAnimation = TweenSequence<double>(
        [
          TweenSequenceItem(
            tween: Tween<double>(
              begin: finalIndicatorWidth,
              end: itemWidth / 2,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: itemWidth / 2,
              end: finalIndicatorWidth,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 50,
          ),
        ],
      ).animate(_controller);

      _controller.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final int itemCount = widget.items.length;
        final double itemWidth = totalWidth / itemCount;

        // Si la animación no ha iniciado (o no hay cambios), usamos el indicador con finalIndicatorWidth y centrado.
        double currentCenter = widget.currentIndex * itemWidth + itemWidth / 2;
        double currentWidth = finalIndicatorWidth;

        return Stack(
          children: [
            // Contenedor de la fila de ítems con borde superior.
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 3,
                    color: widget.items[widget.currentIndex].color,
                  ),
                ),
              ),
              child: Row(
                children: widget.items.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final CustomBottomNavigationBarItem item = entry.value;
                  final bool isSelected = index == widget.currentIndex;
                  return Expanded(
                    child: InkWell(
                      onTap: () => widget.onTap(index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? item.color : AppTheme.silverBlue,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected ? item.color : AppTheme.silverBlue,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Indicador inferior animado.
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Si la animación se ha disparado, usar los valores animados; si no, usar los valores por defecto.
                if (_controller.status != AnimationStatus.dismissed) {
                  currentCenter = _centerAnimation.value;
                  currentWidth = _widthAnimation.value;
                }
                final double leftPosition = currentCenter - (currentWidth / 2);
                return Positioned(
                  left: leftPosition,
                  bottom: 4,
                  width: currentWidth,
                  height: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.items[widget.currentIndex].color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
