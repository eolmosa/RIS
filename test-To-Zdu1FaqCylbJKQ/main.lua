local function trace(a,b,c,d) return end

-- Added by Eduardo Olmos on 07/06/2015
-- The purpose of this code is to remove prefix from MRN and ensure to send only DFTs that belong to NextGen (Accession starts with NGP).
function main(Data)
   
   local Msg, Name = hl7.parse{data=Data, vmd='Standard Oracle-PowerScribe-Inbound.vmd'} 
   local Out = hl7.message{name=Name, vmd='Standard Oracle-PowerScribe-Inbound.vmd'} 
   
   
      local PID3 = Msg.PID[3][1]:nodeValue()
      crosswalk(PID3,'c:\\crosswalk.txt')
      Out:mapTree(Msg)
      Out.PID[3][1] = PID3Modified      
      local DataOut = Out:S()
      queue.push{data=DataOut}   
end

function replace(value)
   return table.concat(value:split(","),"~")
end

function crosswalk(value, fileName)
   local startIndex
   local endIndex
   local result 
   local line
   local stringToSearch
   local substringInputValue 
   
   file = io.open(fileName, "r")
   line = file:read("*all")
   stringToSearch = '\n'..value..','
   startIndex, endIndex = line:find(stringToSearch)
   
   if startIndex ~= nil then
      
      substringInputValue = line:sub(endIndex + 1)
      result = substringInputValue:split('\n')[1]
   
   else
   
      result = value
      
   end
   
   return result
   
end