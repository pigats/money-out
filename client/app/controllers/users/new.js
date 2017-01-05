import Ember from 'ember';

export default Ember.Controller.extend({
    actions: {
        createUser() {
            let user = this.get('model');
            user.set('email', this.get('email'));
            user.set('password', this.get('password'));

            user.save();
            
        }
    }
});
