import DS from 'ember-data';
import config from '../config/environment';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default DS.JSONAPIAdapter.extend(DataAdapterMixin, {
    host: config.api_host,
    namespace: 'api',
    authorizer: 'authorizer:jwt'
});
