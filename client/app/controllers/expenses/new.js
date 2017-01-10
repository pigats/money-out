import Ember from 'ember';

export default Ember.Controller.extend({
    me: Ember.inject.service('current-user'),

    actions: {
        createExpense(params) {
            this.set('model.date', new Date(params.get('date')));
            this.set('model.description', params.get('description'));
            this.set('model.amount', params.get('amount'));
            this.set('model.comment', params.get('comment'));
            this.set('model.user', this.get('me.user'));

            this.get('model').save().then(() => this.transitionToRoute('expenses')).catch(errors => console.log());
        }
    }
});
