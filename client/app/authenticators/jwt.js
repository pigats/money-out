import Base from 'ember-simple-auth/authenticators/base';
import Ember from 'ember';
import config from '../config/environment';

export default Base.extend({
    authenticationEndpoint: `${config.host}/session`,

    restore(data) {
        return new Ember.RSVP.Promise((resolve, reject) => {
            if(!Ember.isEmpty(data.token)) {
                resolve(data);
            } else {
                reject();
            }
        });
    },

    authenticate(email, password) {
        const payload = JSON.stringify({
            auth: {
                email,
                password
            }
        });

        return new Ember.RSVP.Promise((resolve, reject) => {
            return $.ajax({
                url: this.get('authenticationEndpoint'),
                type: 'POST',
                data: payload,
                contentType: 'application/json',
                dataType: 'json'
            }).done(response =>
                resolve({ token: response.jwt })
            ).fail(error =>
                reject(error)
            );
        });
        
    },

    invalidate(data) {
      return Ember.RSVP.Promise.resolve(data);
    }
});
