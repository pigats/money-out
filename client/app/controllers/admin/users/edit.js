import AdminUsersNewController from './new';

export default AdminUsersNewController.extend({
    actions: {
        editUser(params) {
            this.send('createUser', params);
        }
    }
});
