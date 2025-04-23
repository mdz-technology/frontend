// widgets/custom_cupertino_drawer.dart (Versión para GlobalKey con Prints de Debug para Cierre)

import 'package:flutter/material.dart'; // Necesario para State, AnimationController, Material, GestureDetector, Colors, etc.

// Ya no necesitamos Provider/DrawerState para el control de apertura/cierre

// Define un tipo para la GlobalKey, facilitando su uso y asegurando que el tipo State es correcto.
// Asegúrate que '_CustomCupertinoDrawerState' coincida con el nombre de la clase State abajo.
typedef CustomCupertinoDrawerStateKey = GlobalKey<CustomCupertinoDrawerState>;

class CustomCupertinoDrawer extends StatefulWidget {
  final Widget drawerContent; // El widget a mostrar en el panel lateral
  final Widget child;         // El contenido principal (el body del scaffold)
  final double drawerWidth;   // Ancho del panel del drawer
  final Duration animationDuration; // Duración de la animación de apertura/cierre
  final Color scrimColor;      // Color del velo sobre el contenido principal

  const CustomCupertinoDrawer({
    // Acepta la GlobalKey que le pasará ScaffoldBuilder
    required CustomCupertinoDrawerStateKey key,
    required this.drawerContent,
    required this.child,
    this.drawerWidth = 280.0,
    this.animationDuration = const Duration(milliseconds: 250),
    this.scrimColor = Colors.black54,
  }) : super(key: key); // Pasa la key al constructor de StatefulWidget

  @override
  // El tipo de State debe coincidir con el usado en el typedef de la GlobalKey
  State<CustomCupertinoDrawer> createState() => CustomCupertinoDrawerState();
}

// La clase State puede mantenerse privada (_) si el typedef es público
class CustomCupertinoDrawerState extends State<CustomCupertinoDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scrimFadeAnimation;

  // Ya no es necesario '_isDrawerOpenState' si nos basamos en el status del controller

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCubic),
    );
    _scrimFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    print("[CustomCupertinoDrawerState] initState completado.");
  }

  @override
  void dispose() {
    print("[CustomCupertinoDrawerState] dispose llamado.");
    _animationController.dispose();
    super.dispose();
  }

  // --- MÉTODO PÚBLICO (Llamado por GlobalKey desde AppBarBuilder) ---
  void toggle() {
    // Comprobar si el widget todavía está montado antes de actuar
    if (!mounted) {
      print("[CustomCupertinoDrawerState] toggle() llamado pero widget no montado.");
      return;
    }
    print("[CustomCupertinoDrawerState] toggle() llamado via GlobalKey.");
    final status = _animationController.status;
    // Si está cerrado (dismissed) o retrocediendo (reverse), iniciar animación hacia adelante
    if (status == AnimationStatus.dismissed || status == AnimationStatus.reverse) {
      print("[CustomCupertinoDrawerState] toggle: Iniciando animación forward()...");
      _animationController.forward();
    }
    // Si está abierto (completed) o avanzando (forward), iniciar animación hacia atrás
    else if (status == AnimationStatus.completed || status == AnimationStatus.forward) {
      print("[CustomCupertinoDrawerState] toggle: Iniciando animación reverse()...");
      _animationController.reverse();
    }
  }

  // --- MÉTODO PRIVADO (Llamado por el onTap del Scrim) ---
  void _closeDrawer() {
    if (!mounted) {
      print("[CustomCupertinoDrawerState] _closeDrawer() llamado pero widget no montado.");
      return;
    }
    // *** PRINT: Confirma que se llamó a este método ***
    print("[CustomCupertinoDrawerState] _closeDrawer() llamado.");
    final status = _animationController.status;
    // *** PRINT: Muestra estado actual al intentar cerrar ***
    print("[CustomCupertinoDrawerState] _closeDrawer: Status actual = $status, Valor = ${_animationController.value.toStringAsFixed(3)}");
    // Solo intentar revertir si está completado o avanzando (abierto o abriéndose)
    if (status == AnimationStatus.completed || status == AnimationStatus.forward) {
      // *** PRINT: Confirma que se llamará a reverse() ***
      print("[CustomCupertinoDrawerState] _closeDrawer: Llamando a reverse()...");
      _animationController.reverse();
    } else {
      // *** PRINT: Indica por qué no se llamó a reverse() ***
      print("[CustomCupertinoDrawerState] _closeDrawer: No se llama a reverse() porque el status es $status.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Imprime en cada build para ver el valor actual del controlador
    print("[CustomCupertinoDrawer] Build method run. Controller value: ${_animationController.value.toStringAsFixed(3)}");

    return Stack(
      children: [
        // 1. Contenido del Drawer (Debajo, fijo a la izquierda)
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          width: widget.drawerWidth,
          child: widget.drawerContent,
        ),

        // 2. Scrim (Velo semitransparente para cerrar al tocar)
        // Anima su opacidad y controla si es interactivo
        FadeTransition(
          opacity: _scrimFadeAnimation,
          child: IgnorePointer(
            // Ignorar taps si la animación NO está completa Y el valor es menor a 0.9 (ajustable)
            // Esto evita que el tap inicial lo cierre y permite cerrar cuando está casi abierto.
            ignoring: !(_animationController.status == AnimationStatus.completed || _animationController.value >= 0.9),
            // Usamos Builder aquí para poder imprimir el valor de 'ignoring' en el momento del tap
            child: Builder(
                builder: (BuildContext context) {
                  // Calculamos si se está ignorando para el print de depuración
                  bool isIgnoring = !(_animationController.status == AnimationStatus.completed || _animationController.value >= 0.9);
                  return GestureDetector(
                    onTap: () {
                      // *** PRINT: Para saber si el tap fue detectado y si se estaba ignorando ***
                      print("[Scrim GestureDetector] onTap DETECTADO! Ignorando taps?: $isIgnoring (Status: ${_animationController.status}, Value: ${_animationController.value.toStringAsFixed(3)})");
                      // Solo llamar a _closeDrawer si NO se estaba ignorando
                      if (!isIgnoring) {
                        _closeDrawer();
                      }
                    },
                    // Captura taps en toda el área del Container
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      // Cubre toda el área del Stack, pero solo es interactivo cuando IgnorePointer lo permite
                      color: widget.scrimColor,
                    ),
                  );
                }
            ),
          ),
        ),

        // 3. Contenido Principal (Child) - Se desliza horizontalmente
        AnimatedBuilder(
          animation: _slideAnimation, // Escucha la animación de deslizamiento
          builder: (context, bodyChild) {
            final slideAmount = widget.drawerWidth * _slideAnimation.value;
            return Transform.translate(
              offset: Offset(slideAmount, 0),
              // Material para poder usar 'elevation' (sombra)
              child: Material(
                elevation: _slideAnimation.value > 0.1 ? 8.0 : 0.0,
                // Es importante que 'bodyChild' tenga un fondo no transparente
                // para que la sombra se vea bien.
                child: bodyChild,
              ),
            );
          },
          child: widget.child, // El widget body pasado desde ScaffoldBuilder
        ),
      ],
    );
  }
}