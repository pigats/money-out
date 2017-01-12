import AdminExpensesNewController from './new';

export default AdminExpensesNewController.extend({
    actions: {
        editExpense(params) {
            this.send('createExpense', params);
        }
    }
});
