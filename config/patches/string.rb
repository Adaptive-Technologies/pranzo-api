class String
  def clean_up_xml_string
    <<~AID
      Removes whitespaces and line breaks .
      Also removes whitespace between tags.
      Used in reading XML fixture files allowing 
      us to use formatted XML when stubbing 
      Valvat requests.
    AID
    squish.gsub('> <', '><')
  end
end
