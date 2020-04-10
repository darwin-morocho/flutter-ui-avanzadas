# Fultter Advances UI

Este proyecto contiene ejemplos de UIs avanzadas en flutter.

## Ejemplos
- Pantalla de Login.
- Pantalla de solicitud a la ubicación del dispositivo.
- Pantalla de chat.

<img width="200" alt="Captura de Pantalla 2020-04-10 a la(s) 18 26 09" src="https://user-images.githubusercontent.com/15864336/79029153-c45d2a80-7b58-11ea-8564-a26734fb7879.png">

<img width="200" alt="Captura de Pantalla 2020-04-10 a la(s) 18 25 32" src="https://user-images.githubusercontent.com/15864336/79029166-d63ecd80-7b58-11ea-95c4-236f1b1527f2.png">


<img width="200" alt="Captura de Pantalla 2020-04-10 a la(s) 18 23 28" src="https://user-images.githubusercontent.com/15864336/79029176-e3f45300-7b58-11ea-8a06-cc85ff32270e.png">


<img width="200" alt="Captura de Pantalla 2020-04-10 a la(s) 18 24 40" src="https://user-images.githubusercontent.com/15864336/79029184-ed7dbb00-7b58-11ea-8cfd-23ae954a0a78.png">


---
Para ejecutar el proyecto es necesario configurar firebase/core y firebase/storage (NO hace falta instalarlos unicamente debe realizar la siguiente confirguración).


Primero cambie el packagename del proyecto android y el bundle id en el proyecto iOS.

En su consola de firebase cree un nuevo proyecto y agrege las plataformas iOS y android con los respectivos bundle id y packagename.


Agregue el archivo `google-services.json` en el folder `android/app`.

Agregue el archivo `GoogleService-Info.plist` al proyecto ios (https://firebase.google.com/docs/ios/setup#add-config-file).

Luego en su consola de firebase habilite `firebase storage` y deshabilite la autenticación para leer y escribir archivos.
<img width="374" alt="rules" src="https://user-images.githubusercontent.com/15864336/79029040-3c772080-7b58-11ea-9ffc-883062a2d2af.png">



