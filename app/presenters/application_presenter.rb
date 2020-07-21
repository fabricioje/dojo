class ApplicationPresenter

  def initialize(object = nil, code = nil)
    @object  = object
    @code   = code
  end

  def as_json
    body = valid? ? success : error
    return { json: body, status: get_http_status }
  end

  def as_json_collection(pagination_info)

    headers = {
      "X-Total-Items" => pagination_info[:total_items].to_s,
      "X-Total-Pages" => pagination_info[:total_pages].to_s,
      "Link"          => build_link_http_header(pagination_info[:page],
                                                pagination_info[:per_page],
                                                pagination_info[:total_pages])
    }

    body              = @object.map { |m| success(m) }
    rendered_response = { json: body, status: get_http_status }

    [rendered_response, headers]

  end

  # who extends this class must implements 'success' method
  def success(object = nil)
    obj  = object.nil? ? @object : object
    # json = obj.attributes.except('id', 'created_at', 'updated_at')
    json = obj

    res = json.map{ |data|
      data.attributes.except('id', 'created_at', 'updated_at')
    }

    # json.each { |k, v| json.delete(k) if v.nil? }

    return res
    
  end

  def error
    error           = {}
    error[:status]  = get_http_status
    error[:code]    = get_error_code
    error[:message] = get_error_message
    # error[:errors]  = @object.errors.messages if !(@object.nil? or @object.errors.blank?)
    # error[:see]     = get_error_link
    error
  end

  def get_http_status
    HTTP_STATUSES[@code]
  end

  def get_error_code
     "#{ERROR_CODES[@code]}_error"
  end

  def get_error_message
    ERROR_MESSAGES[@code]
  end

  def get_error_link
    ERROR_LINKS[@code]
  end

  # O presenter deve considerar valido os objetos que:
  # 1. Não forem nil
  # 2. Model valido (nenhum erro de validação)
  # 3. O http status code for da familia 2xx
  def valid?

    # !@object.nil? and @object.valid? and (get_http_status < 300) #and @object.kind_of?(Array)
    !@object.nil? and (get_http_status < 300)
  end

  def build_link_http_header(page, per_page, total_pages)
    link_http_header  = build_link_item_http_header(page, per_page, total_pages, 'first')
    link_http_header += build_link_item_http_header(page, per_page, total_pages, 'prev')
    link_http_header += build_link_item_http_header(page, per_page, total_pages, 'next')
    link_http_header += build_link_item_http_header(page, per_page, total_pages, 'last')
    link_http_header
  end

  def build_link_item_http_header(page, per_page, total_pages, rel)

    base_url      = ENV['BASE_URL']
    finalization  = ', '

    if (rel == 'first')
      page = 1
    elsif (rel == 'prev')
      if(page > 1)
        page -= 1
      else
        return ""
      end
    elsif (rel == 'next')
      if(page < total_pages)
        page += 1
      else
        return ""
      end
    elsif (rel == 'last')
      page = total_pages
      finalization = ''
    end

    link_item = "<#{base_url}/#{get_find_all_resource}?page=#{page}&per_page=#{per_page}>; rel='#{rel}'#{finalization}"
    link_item

  end


  # who extends this class must implements 'get_find_all_resource' method
  def get_find_all_resource
    'not implemented'
  end

  HTTP_STATUSES = {
    :validation_error             => 400,
    :created                      => 201,
    :loaded                       => 200,
    :ok                           => 200,
    :item_not_found               => 404,
    :transition_not_accepted      => 422,
    :idempotency_key_not_present  => 422,
    :invalid_merchant_account     => 404,
    :internal_server_error        => 500,
    :bad_gateway                  => 502,
    :invalid_affiliation_key      => 500,
    :insufficient_funds           => 422,
    :kind_not_available           => 404
  }

  ERROR_CODES = {
    :validation_error             => :validation,
    :item_not_found               => :item_not_found,
    :transition_not_accepted      => :transition_not_accepted,
    :idempotency_key_not_present  => :idempotency_key,
    :invalid_merchant_account     => :invalid_merchant_account,
    :internal_server_error        => :internal_server,
    :bad_gateway                  => :bad_gateway,
    :invalid_affiliation_key      => :invalid_affiliation_key,
    :insufficient_funds           => :insufficient_funds,
    :kind_not_available           => :kind_not_available
  }

  ERROR_MESSAGES = {
    :validation_error             => "One or more fields are required and / or in an invalid format",
    :item_not_found               => "The requested item was not found",
    :transition_not_accepted      => "The requested transition of status is not accepted",
    :idempotency_key_not_present  => "The custom header field X-Idempotency-Key is required",
    :invalid_merchant_account     => "The Merchant account was not found",
    :internal_server_error        => "Internal Server Error",
    :bad_gateway                  => "Bad gateway",
    :invalid_affiliation_key      => "Invalid Supplier Key",
    :insufficient_funds           => "Insufficient Funds",
    :kind_not_available           => "Kind Not Available"
  }

  ERROR_LINKS = {
    :validation_error             => "https://docs.rvhub.com.br/errors#validation_error",
    :item_not_found               => "https://docs.rvhub.com.br/errors#item_not_found_error",
    :transition_not_accepted      => "https://docs.rvhub.com.br/errors#transition_not_accepted_error",
    :idempotency_key_not_present  => "https://docs.rvhub.com.br/errors#idempotency_key_not_present_error",
    :invalid_merchant_account     => "https://docs.rvhub.com.br/errors#invalid_merchant_account_error",
    :internal_server_error        => "https://docs.rvhub.com.br/errors#internal_server_error",
    :bad_gateway                  => "https://docs.rvhub.com.br/errors#bad_gateway_error",
    :invalid_affiliation_key      => "https://docs.rvhub.com.br/errors#invalid_affiliation_key_error",
    :insufficient_funds           => "https://docs.rvhub.com.br/errors#insufficient_funds_error",
    :kind_not_available           => "https://docs.rvhub.com.br/errors#kind_not_available"
  }

end
