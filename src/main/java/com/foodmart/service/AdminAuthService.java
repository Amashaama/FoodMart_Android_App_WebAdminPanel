package com.foodmart.service;

import com.foodmart.config.FirebaseConfig;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Simple helper service to validate admin credentials against Firestore.
 * Collection: admins
 * Fields: email (String), password (String)
 */
public class AdminAuthService {

    private static final Logger LOGGER = Logger.getLogger(AdminAuthService.class.getName());

    /**
     * Check if there is an admin document with the given email and password.
     * No hashing / advanced security – this is intentionally simple for a student demo.
     */
    public boolean isValidAdmin(String email, String password) {
        if (email == null || password == null) {
            return false;
        }

        email = email.trim();
        password = password.trim();
        if (email.isEmpty() || password.isEmpty()) {
            return false;
        }

        try {
            Firestore db = FirebaseConfig.getDb();
            if (db == null) {
                LOGGER.warning("Firestore is not initialized (FirebaseConfig.getDb() returned null)");
                return false;
            }

            CollectionReference adminsRef = db.collection("admin");
            Query query = adminsRef.whereEqualTo("email", email).whereEqualTo("password", password).limit(1);
            ApiFuture<QuerySnapshot> future = query.get();
            QuerySnapshot snapshot = future.get();

            if (snapshot == null) {
                return false;
            }

            List<QueryDocumentSnapshot> docs = snapshot.getDocuments();
            return docs != null && !docs.isEmpty();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error validating admin credentials from Firestore", e);
            return false;
        }
    }
}
