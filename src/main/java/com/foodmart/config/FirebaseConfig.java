package com.foodmart.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import com.google.firebase.cloud.StorageClient;

import java.io.IOException;
import java.io.InputStream;

public class FirebaseConfig {

    private static Firestore firestore;

    public static synchronized Firestore getDb() {
        if (firestore == null) {
            initialize();
        }
        return firestore;
    }

    public static synchronized StorageClient getStorage() {
        if (FirebaseApp.getApps() == null || FirebaseApp.getApps().isEmpty()) {
            initialize();
        }
        return StorageClient.getInstance();
    }

    private static void initialize() {
        try {
            if (FirebaseApp.getApps() != null && !FirebaseApp.getApps().isEmpty()) {
                firestore = FirestoreClient.getFirestore();
                return;
            }

            InputStream serviceAccount = null;

            // 1. Check raw JSON string from environment variable (ideal for cloud hosting like Render/Railway/Koyeb)
            String jsonEnv = System.getenv("FIREBASE_SERVICE_ACCOUNT_JSON");
            if (jsonEnv != null && !jsonEnv.trim().isEmpty()) {
                serviceAccount = new java.io.ByteArrayInputStream(jsonEnv.trim().getBytes(java.nio.charset.StandardCharsets.UTF_8));
            }

            // 2. Check base64 encoded JSON from environment variable
            if (serviceAccount == null) {
                String base64Env = System.getenv("FIREBASE_SERVICE_ACCOUNT_BASE64");
                if (base64Env != null && !base64Env.trim().isEmpty()) {
                    byte[] decoded = java.util.Base64.getDecoder().decode(base64Env.trim());
                    serviceAccount = new java.io.ByteArrayInputStream(decoded);
                }
            }

            // 3. Check custom file path from environment variable
            if (serviceAccount == null) {
                String pathEnv = System.getenv("FIREBASE_CONFIG_PATH");
                if (pathEnv == null || pathEnv.trim().isEmpty()) {
                    pathEnv = System.getenv("GOOGLE_APPLICATION_CREDENTIALS");
                }
                if (pathEnv != null && !pathEnv.trim().isEmpty()) {
                    java.io.File file = new java.io.File(pathEnv.trim());
                    if (file.exists()) {
                        serviceAccount = new java.io.FileInputStream(file);
                    }
                }
            }

            // 4. Fallback to classpath resource (src/main/resources/firebase-service-account.json)
            if (serviceAccount == null) {
                serviceAccount = FirebaseConfig.class.getClassLoader()
                        .getResourceAsStream("firebase-service-account.json");
            }

            if (serviceAccount == null) {
                throw new IllegalStateException("Firebase credentials not found! Please place 'firebase-service-account.json' in 'src/main/resources' or set the 'FIREBASE_SERVICE_ACCOUNT_JSON' environment variable.");
            }

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .setStorageBucket("foodmart-61a88.firebasestorage.app")
                    .build();

            FirebaseApp.initializeApp(options);
            firestore = FirestoreClient.getFirestore();
        } catch (IOException e) {
            throw new RuntimeException("Failed to initialize Firebase", e);
        }
    }
}
