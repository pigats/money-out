import ExpenseItem from './expense-item';

export default ExpenseItem.extend({
    me: Ember.inject.service('current-user'),
});
