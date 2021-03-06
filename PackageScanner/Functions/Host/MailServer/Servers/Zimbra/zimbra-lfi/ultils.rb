# /usr/bin/ruby

require 'net/https'

class Utils

def request_soap_admin(api_call)

  @request=api_call
  
  soap_client = Net::HTTP.new( $host, 7071 )
  soap_client.use_ssl = true
  soap_client.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
  soap_path = "/service/admin/soap"
  
  soap_data = "<soap:Envelope xmlns:soap=\"http://www.w3.org/2003/05/soap-envelope\"><soap:Header><context xmlns=\"urn:zimbra\"><authToken>#{$auth_key}</authToken></context></soap:Header><soap:Body>#{@request}</soap:Body></soap:Envelope>"
  
  response = soap_client.post(soap_path, soap_data, { "Content-Type" => "application/soap+xml; charset=utf-8; action=\"urn:zimbraAdmin\"" } )
  
  if response.body.match(/Error/)
     error_res = response.body.match(/<soap:Text>(.*?)<\/soap:Text>/ui)[1]
     puts "[-] Response Error"
     puts "    [*] #{error_res}"
     false
  else
     return response.body
  end    
  

end
end
