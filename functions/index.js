'use strict';

const functions = require('firebase-functions'),
	admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const stripe = require('stripe')(functions.config().stripe.sk_test_wcjBJ4P8fF1rLTIPbi1E9vJs);

// When a user is created, register them with Stripe
exports.createStripeCustomer = functions.auth.user().onCreate(event => {
	const data = event.data;
	return stripe.customers.create({
		email: data.email
	}).then (customer => {
		return admin.database().ref('/stripe_customers/${data.uid}/customer_id').set(customer.id);
	});
	console.log("Successful key created")
});
