'use strict';

const functions = require('firebase-functions'),
	admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const stripe = require('stripe')(functions.config().stripe.token);


// When a user is created, register them with Stripe
exports.createStripeCustomer = functions.auth.user().onCreate(event => {
	const user = event.data;
	return stripe.customers.create({
		email: user.email
	}).then (customer => {
		const data = { customerId: customer.id }
      
      const updates = {}
      updates[`/customers/${customer.id}`]     = user.uid
      updates[`/users/${user.uid}/customerId`] = customer.id
      
      
      return admin.database().ref().update(updates);
	});
	console.log("Successful key created")
});
