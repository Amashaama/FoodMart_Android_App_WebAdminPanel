package com.foodmart.dao;

import com.foodmart.config.FirebaseConfig;
import com.foodmart.model.Order;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;

import java.util.ArrayList;
import java.util.List;

public class OrderDao {

    public List<Order> findAll() {
        List<Order> orders = new ArrayList<>();
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("orders").orderBy("createdAt", Query.Direction.DESCENDING).get();
            List<QueryDocumentSnapshot> docs = future.get().getDocuments();
            if (docs != null) {
                for (QueryDocumentSnapshot doc : docs) {
                    Order o = map(doc);
                    if (o != null) {
                        orders.add(o);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public long count() {
        try {
            Firestore db = FirebaseConfig.getDb();
            ApiFuture<QuerySnapshot> future = db.collection("orders").get();
            QuerySnapshot snapshot = future.get();
            if (snapshot != null && snapshot.getDocuments() != null) {
                return snapshot.getDocuments().size();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0L;
    }

    public void updateStatus(String orderId, String status) {
        if (orderId == null || status == null) return;
        try {
            Firestore db = FirebaseConfig.getDb();
            db.collection("orders").document(orderId).update("status", status);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Order map(DocumentSnapshot doc) {
        if (doc == null) return null;
        Order o = new Order();
        o.setOrderId(doc.getId());
        o.setUserId(doc.getString("userId"));
        o.setFullName(doc.getString("fullName"));
        o.setEmail(doc.getString("email"));
        o.setPhone(doc.getString("phone"));
        o.setAddressLine1(doc.getString("addressLine1"));
        o.setAddressLine2(doc.getString("addressLine2"));
        o.setCity(doc.getString("city"));
        o.setPostalCode(doc.getString("postalCode"));
        o.setDeliveryType(doc.getString("deliveryType"));
        try {
            Double fee = doc.getDouble("deliveryFee");
            o.setDeliveryFee(fee != null ? fee : 0.0);
        } catch (Exception e) {
            o.setDeliveryFee(0.0);
        }
        o.setPaymentMethod(doc.getString("paymentMethod"));
        o.setPaymentReference(doc.getString("paymentReference"));
        try {
            Double subtotal = doc.getDouble("subtotal");
            o.setSubtotal(subtotal != null ? subtotal : 0.0);
        } catch (Exception e) {
            o.setSubtotal(0.0);
        }
        try {
            Double total = doc.getDouble("total");
            o.setTotal(total != null ? total : 0.0);
        } catch (Exception e) {
            o.setTotal(0.0);
        }
        o.setStatus(doc.getString("status"));
        try {
            Long created = doc.getLong("createdAt");
            o.setCreatedAt(created);
        } catch (Exception e) {
            o.setCreatedAt(null);
        }
        return o;
    }
}
