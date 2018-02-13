'use strict';

const functions = require('firebase-functions'),
	admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const stripe = require('stripe')(functions.config().stripe.token);


// When a user is created, register them with Stripe
exports.createStripeCustomer = functions.auth.user().onCreate(event => {
	const user = event.data;
	const uid = user.uid;
	return stripe.customers.create({
		email: user.email
	}).then (customer => {
		var stripeDatabase = admin.database().ref('/stripe_customers/');
		var idChild = stripeDatabase.child(uid);
		idChild.set ({
			email: user.email,
			customer_id: customer.id
		})
    	return admin.database().ref(`/stripe_customers/${user.uid}/customer_id`).set(customer.id);
	});
	console.log("Successful key created");
});
