class ResourcesController < ApplicationController

  inherit_resources
  load_and_authorize_resource

end