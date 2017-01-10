require 'active_model_serializers/register_jsonapi_renderer'

ActiveModelSerializers.config.adapter = :json_api
ActiveModelSerializers.config.jsonapi_resource_type = :singular
