'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/apple-icon.png": "a6c470084fbd043c694e7562117a1af2",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/apple-icon-114x114.png": "c09d107c39dddaf0b7e756fd282dadc2",
"icons/apple-icon-60x60.png": "c5f0ac3123ab0a51bf292dc016838aea",
"icons/ms-icon-70x70.png": "dde1c189a38653da979725ff67d275f9",
"icons/Icon-512.png": "a86dc01461f759ef51f54114d410800d",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"icons/Icon-192.png": "4da8f0e6ba4dc07235aa29146b1e46c8",
"icons/apple-icon-120x120.png": "d2c1166db412ef7d18db060d7d222472",
"icons/android-icon-192x192.png": "ad6c228997ac6481fc063e2b7e9272b5",
"icons/ms-icon-310x310.png": "9a02fbf819436477ad98d89c8a8642a6",
"icons/android-icon-36x36.png": "cc6b89721a12868df553ae62dc67a3a0",
"icons/android-icon-72x72.png": "70e53f5ecb8b2f0dd3630971ad3b0295",
"icons/apple-icon-57x57.png": "4064844265d871b4a476d250a1f7fd87",
"icons/android-icon-48x48.png": "98bbb3d9b9a96670966cfc5ec2d0c124",
"icons/manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"icons/favicon-16x16.png": "97af83012b30e825dcf76971dc68a5c0",
"icons/apple-icon-144x144.png": "85c274fe09c9cab198bfa0b28d548ffa",
"icons/apple-icon-72x72.png": "70e53f5ecb8b2f0dd3630971ad3b0295",
"icons/ms-icon-144x144.png": "85c274fe09c9cab198bfa0b28d548ffa",
"icons/apple-icon-precomposed.png": "a6c470084fbd043c694e7562117a1af2",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/android-icon-96x96.png": "c8980cddeb30b7f57aec72cf6a6e67ee",
"icons/favicon.ico": "4ffdb840cb470ee116a1a3d1fe82d3bb",
"icons/apple-icon-152x152.png": "ef1eefdc993eb4a5fa81929f9fc8b9ac",
"icons/android-icon-144x144.png": "85c274fe09c9cab198bfa0b28d548ffa",
"icons/apple-icon-180x180.png": "6a299dbd1ec67b466af6add6eeb9c802",
"icons/favicon-32x32.png": "f3d848add1b4003e2bfa2224317bfd13",
"icons/favicon-96x96.png": "c8980cddeb30b7f57aec72cf6a6e67ee",
"icons/apple-icon-76x76.png": "ca4bc87521feedff0f42c573506fd3fa",
"icons/ms-icon-150x150.png": "967e0dd73c517b31baa749af8b2b370e",
"version.json": "42c3bc15b96cb284d86528675363faea",
"manifest.json": "3221b2edaaa92bd3ac142bc1537127ce",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"index.html": "34cffc8bea2034d5f30f7ceac14bbc6c",
"/": "34cffc8bea2034d5f30f7ceac14bbc6c",
"flutter.js": "7d69e653079438abfbb24b82a655b0a4",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"main.dart.js": "9566d3050224d0ef38a86bf240d858b0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/AssetManifest.bin": "693635b5258fe5f1cda720cf224f158c",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/AssetManifest.json": "2efbb41d7877d10aac9d091f58ccd7b9",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "202114d5bca552d23cc5bee97545b20c",
"assets/AssetManifest.bin.json": "69a99f98c8b1fb8111c5fb961769fcd8",
"assets/NOTICES": "bc0d00e7f52bc189298f2901b24baa2e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
