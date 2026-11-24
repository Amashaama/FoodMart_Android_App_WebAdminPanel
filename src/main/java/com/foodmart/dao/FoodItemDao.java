package com.foodmart.dao;

import com.foodmart.config.FirebaseConfig;
import com.foodmart.model.FoodItem;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;

import java.util.ArrayList;
import java.util.List;

public class FoodItemDao {

    public List<FoodItem> findAll() {
        List<FoodItem> items = new ArrayList<>();
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("food_items").get();
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();
            if (documents != null) {
                for (QueryDocumentSnapshot doc : documents) {
                    FoodItem item = map(doc);
                    if (item != null) {
                        items.add(item);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public long count() {
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("food_items").get();
            QuerySnapshot snapshot = future.get();
            if (snapshot != null && snapshot.getDocuments() != null) {
                return snapshot.getDocuments().size();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public FoodItem findTopSoldItem() {
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("food_items")
                    .orderBy("soldCount", com.google.cloud.firestore.Query.Direction.DESCENDING)
                    .limit(1)
                    .get();
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();
            if (documents != null && !documents.isEmpty()) {
                return map(documents.get(0));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void toggleAvailability(String itemId) {
        if (itemId == null) return;
        try {
            Firestore db = FirebaseConfig.getDb();
            DocumentReference ref = db.collection("food_items").document(itemId);
            ApiFuture<DocumentSnapshot> future = ref.get();
            DocumentSnapshot doc = future.get();
            if (doc != null && doc.exists()) {
                Boolean available = doc.getBoolean("available");
                boolean newValue = (available == null) ? true : !available;
                ref.update("available", newValue);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private FoodItem map(DocumentSnapshot doc) {
        if (doc == null) return null;
        FoodItem f = new FoodItem();
        f.setItemId(doc.getId());
        f.setSellerId(doc.getString("sellerId"));
        f.setItemName(doc.getString("itemName"));
        f.setItemDescription(doc.getString("itemDescription"));
        f.setCategoryId(doc.getString("categoryId"));
        f.setCategoryName(doc.getString("categoryName"));
        try {
            Double price = doc.getDouble("itemPrice");
            f.setItemPrice(price != null ? price : 0.0);
        } catch (Exception e) {
            f.setItemPrice(0.0);
        }
        try {
            Long qtyLong = doc.getLong("quantity");
            f.setQuantity(qtyLong != null ? qtyLong.intValue() : 0);
        } catch (Exception e) {
            f.setQuantity(0);
        }
        f.setPortionSize(doc.getString("portionSize"));
        Boolean available = doc.getBoolean("available");
        f.setAvailable(available != null ? available : Boolean.FALSE);
        @SuppressWarnings("unchecked")
        List<String> images = (List<String>) doc.get("imageUris");
        f.setImageUris(images);
        f.setSellerAddress(doc.getString("sellerAddress"));
        f.setSellerCity(doc.getString("sellerCity"));
        try {
            Double lat = doc.getDouble("sellerLatitude");
            f.setSellerLatitude(lat);
        } catch (Exception e) {
            f.setSellerLatitude(null);
        }
        try {
            Double lng = doc.getDouble("sellerLongitude");
            f.setSellerLongitude(lng);
        } catch (Exception e) {
            f.setSellerLongitude(null);
        }
        try {
            Long created = doc.getLong("createdAt");
            f.setCreatedAt(created);
        } catch (Exception e) {
            f.setCreatedAt(null);
        }
        try {
            Long sold = doc.getLong("soldCount");
            f.setSoldCount(sold != null ? sold.intValue() : 0);
        } catch (Exception e) {
            f.setSoldCount(0);
        }
        return f;
    }
}
