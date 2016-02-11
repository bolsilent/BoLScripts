
--[[

To Do list




check for braum shield/immunities
option to stun cc'd enemys
add nebels multiple predictions
Full combo's but what skills cost less mana and could kill
Save Q for squishies


]]--
require "VPrediction"
require "SourceLib"
require "UPL"
if myHero.charName ~= "Brand" then return end

local version = "2.1"


local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "SilentBrand"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/bolsilent/BoLScripts/master/SilentBrand.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local ServerData
if autoupdateenabled then
    GetAsyncWebResult(UPDATE_HOST, UPDATE_PATH, function(d) ServerData = d end)
    function update()
        if ServerData ~= nil then
            local ServerVersion
            local send, tmp, sstart = nil, string.find(ServerData, "local version = \"")
            if sstart then
                send, tmp = string.find(ServerData, "\"", sstart+1)
            end
            if send then
                ServerVersion = tonumber(string.sub(ServerData, sstart+1, send-1))
            end

            if ServerVersion ~= nil and tonumber(ServerVersion) ~= nil and tonumber(ServerVersion) > tonumber(version) then
                DownloadFile(UPDATE_URL.."?nocache"..myHero.charName..os.clock(), UPDATE_FILE_PATH, function () print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> successfully updated. Reload (double F9) Please. ("..version.." => "..ServerVersion..")</font>") end)
            elseif ServerVersion then
                print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> You have got the latest version: <u><b>"..ServerVersion.."</b></u></font>")
            end
            ServerData = nil
        end
    end
    AddTickCallback(update)
end



_G.ScriptCode = Base64Decode("jrLW1LZmYmh3a2xmgPRxfYB9ZmFzZGZhZHNnZYCNYmRzbHOmYXqkpmF/s2dkfSdh5Hnms2aiM2RmfqRzaINm52Fqc6ZzbWG0ZIGhZHN+JGbnZ+SzZrSmYnOBpmFlkmfkZm1hpHNts6ZhtORnYepzp2TtZ6JlNOZ0Zmc0pWanJbRn6mepYeu0qHYn4nVkA+JkdC1lqGcopTVpdChjc0HnYWV5aaZmbqOmd6d1aWGQ5mZiqnWpZK2pI2j0qHZmvvVkZ+dmtWfrqKlmJfVpcwPjc2X84mZ2xGVmaH7lc2Z/J6R15WdlZDSoaGaE4mR1fHNnYbnkqmHkc2dkw+dhZXNm82anc6RmqyQ356pmp2GuM6r1rGG4ZK2hKXPtZKhn6OS4ZxDm4XPzJqZlNGdqZsSh5HSsc6thuqQsYeXzbWQnJ2dk0ObzZ+xzZGYiZHpnZGfnYaV0bXNHYXXkLKKrcy7lLWphZnNnuWimc6uoJ2j0KWtmKGNsc8N15mJQpWZhRLNk4yxnpmQ6pjlnYnRrZqKle2dB5udiavSuc20iu2a0IuRzhOVmaKflu2a6Jyl15GfhZdDoZGcnYeR1p3RvYf8lqWFltXBky2lhZBDnc2hhc2Rp7eW8Z2VocGGwNa9zw+NzZbZjLncE5WZp7aW9aRDnYXQw56pkvymtZsTjZHS2dTBlwGYtZeX1cWRD6GFmP6c9aT70ZGdhZnNqpGjnZHqzaHdno3dkpmNkd+dm5mh35vVqyGhhdOVoaGQ06W5myKNl86Z2ZmX5565h6zavay1qZGUQ6XNnd/XnbMFmceakaGdl5HVmc3zj9WinY2tz/GZmaCJmembUqGLzpGlhaPnqrGbuJKx6LXZpYhDnZmJ69epqxmlf47Noc2rhdWRod+b1a6Woa2HldW1zO2NzaGdka3MIpmnn4Wfzaj/pqnekauFq82vkbETkZHUyNjBoUOdmYro1amv7amFoy+b2bHjzZObhZ/NrJWlyYbo1aXoGY2/j7OOocydm5mv+5nNnNKhsc2hpYWS56q9m6CRvc8P2ZmLOZ2Zhe7Nx5O1qLWoQ6fNmoXZkbe2nP21lam5hAbbmdPLkP2pnJXBzqGhuZ/6nc2j/aS55ZapuZLNrZGvo5XFzLHerYTqoLGplOHRkQ+thZXRrgWZ3d2lu/qfzaOdpZ2EwtjR5p+WBZEPk5HRCZ2ZneOR25g5pYXN7ZmLkf6sybOjlcnOD9+Zic2dmaXszaOQBqmFkiqZv5W03LW1+6HNofGawaXuzYfLpZPNkfSFe8oJnZmd45H/m+SmvcyRpYWoQ6mRnMmRkc3I3qWj0aHVhSbdnZIOrYWZ0qndmondtZuJoemc5audoZXhtcwcld+TzZitzgKRrcnhkd+bAaih7+WthZYynaHF+YWTzp3dtYfqp62gruGtl9Cxmb4xmvHF4c2Tm7qnCciRrZ2lq+a5zbSe7cKZnZH6E6mZod2j5cRPqW/Lw6rBsdCxzZgQl5HQBt2ZhiqRm4SW1cmQ9amPkeWvDZq34rW4t6cJvpWx2YUF45nTDZnNkg+ZkcydmZnE4J3Ll+Wmhc+upsWtY6mRm8SRnFOx2pmH6p7ZoSTZnZPAq5AWSZvNmpXNkZmVnc2dkxa5haH5mc2a01tbP0djByNHLZ2Vqc2Zz1tPc0tphaIlnZGbGqJLGyeXP0eeyx87Jk9TN2drK0tpmd3Bhc2S5xNbc19ixzNpkd3tzZmHSq5S0x+XQ1Nqyxt2T09zZ1NzSzWFodWdkZsZhaHxmc2bV4tfa083hzmRqamFkc9XmZmV6ZGZhy9jbydTdYWiIZnNmscWzqaa3xra2xbClqcG6vKyquLZmZW1zZ2S7uqa2wafAq2F3cWZhZLa2sba8tanFtLSzpnNodmFkc7e2taqmt8a1xcWtuLqrrWR3emRmZ7G2wqm4ubTCtsWzqcmwt6+2r2R3a3NmYdrX28Nkd2pkZmeGu3NqdGZhc2RqbmRzZ6bH2saap6vhydDXyWZhaHhnZGbUwtjbZndxYXNk2MLS19bR2czGyHNqeGZhc9jPzslzamRmZ2Fkc6ezaWFzZOZsucSoaG1nYWTlx+HK0OBkaWFkc2dkZsChZ3Nmc2Zhc82mZGRzZ2RmZ1Gjd2xzZmHnxcjNyXNra2ZnYc3h2djY1XNnZmFkc2dkpKdkZHNmc2Zhx6RpYWRzZ2Rmi6FoemZzZtTn1s/Py3NraWZnYcfbx+VmZHNkZmFkc2dkamlhZHOUc2plc2Rm1NnVZ2hqZ2Fk38vhZmRzZGZhZHNnpGpvYWRz2NjcxuXXy2Fnc2dkZmdhVDJqeGZhc8bf1clza2ZmZ2Hgc2lzZmFv5z34pXdvZGZn08nk29zYxnNobWFkc9rTydLG2HNqd2Zhc9jJ0WR3cmRmZ9TJ59rc08bi2dphaHtnZGbK0NLhy9baYXd4ZmFk59nNx9OPxuLS1sfU59DLj8fi1GRqbGFkc9nY1MVzaH5hZHOuqbqHkMvY2ufPztiS1snUssrMy8rMoXNqemZhc4rYwtLXpGRpZ2Fkc1bcXqF3pGZhZJOvuLq3kJWhl4BwqeLX2puE59nNx9OPxuLS1sfU59DLj8fi1HFwvNTJ5ZO0zcbh2KCBzLfW29TT0MXXc31za3NobmFkc9nJyczK2thmd2lhc2SQzWR3dGRmZ6PF5supmqXYx9XFyXNramZnYYyYyp6PYXZkZmFkc2fUpmtmZHNm2c/P12RqaGRzZ6CVzM/IsWZ3b2FzZNrQ0ujUxsvZYWh9ZnNmtNbWz9HYuLW6ZmtpZHNmvNm15c3HzWR3dGRmZ6jJ57rlz8LfuM/OyXNrZGZndmRzZo1mYXNlZmV+c2dkq2dhZMBmM2aqc2RmpmRzZ+lm52H5c2Z0f6FzZX2hZPOoZGZnqmRzZrmmoXSr5iFk82dkZsThZHTrc2Zh+eTmYbHz52R/p+HlimZz5q9zJWbnpLNo66aoYiRz5nMEYXNlBWFkc4Zk5mdnZHNmdmZhc2RmYVSya2tmZ2HX59jc1MhzaGthZHPJ3drMYWdzZnNmYVPTpmRkc2dkZmfRpHdrc2Zh1szH02RzZ2RmamFkc2d4Z2NzZGZhZHNnZGZnYWRzZnNmYXOxZmFkwmdkZmhhaHlmc2anc6RmqKQzZ+lm52Ekc2Zzw6HzZYVh5HNpZGZnZWpzZnPawtXQy2FoemdkZtDP19jY52Zhc2RmY2RzZ2RmaHBkc2ZzZmFzZGZhZHNnZGZnxWRzZtpmYXNlZmNuc2dkgadhZIpmc+Zic2RmpmRzZ71m52F7c2bzqaFzZKlh5HPGZGZogGTzZnRmYXNnZmFkc2d8W6dhZHNmdGZhc2VxYWRzZ2RmZ2Fkc2ZzZmFzZM5hZHPSZGZnYmR1bXNmYY6kZmF7c2fkZ2dhZLhmc2avs2RmwGRzaINm52Flc2ZzaWFzZGZhfGinZGZnYWVzZnNnbHNkZmFkc2dkZmdhZHNmc2Zic2RmYmRzZ2RmZ2Fkc2ZzZmFzZGZh")
_G.ScriptENV = _ENV
_G.ScriptName = 'SilentBrand'
_G.ScriptKey = 'Dildo2'
SSL({77,41,33,100,126,211,181,251,253,73,166,122,214,140,93,110,6,10,72,217,201,176,150,212,109,36,25,84,52,17,61,250,11,5,18,37,184,243,172,144,30,34,164,154,215,230,124,213,67,26,239,125,134,53,8,90,237,71,200,69,89,228,88,127,22,198,233,254,180,216,229,28,235,197,136,78,185,170,117,43,114,48,162,156,171,9,177,204,203,123,99,192,31,24,225,21,105,135,141,151,81,116,220,227,240,245,196,218,168,47,236,128,132,153,57,103,12,35,199,209,149,112,97,120,115,163,95,60,94,160,63,248,32,54,210,119,182,80,49,101,82,187,85,87,178,14,20,98,191,2,249,133,7,246,23,111,241,1,188,102,143,66,167,104,179,244,76,13,175,129,207,65,205,19,70,152,3,247,62,15,142,232,74,255,58,107,137,147,234,157,138,16,45,83,131,161,38,146,79,145,68,193,159,50,221,139,206,121,29,224,174,242,91,219,44,46,158,86,59,231,42,173,148,40,4,27,75,51,64,195,96,190,165,194,183,186,189,238,130,155,56,208,106,169,118,92,55,252,202,226,108,39,222,113,223,250,250,250,250,151,81,135,12,220,230,57,81,103,227,236,236,196,144,30,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,57,103,153,240,47,220,230,141,227,105,153,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,57,103,153,240,47,220,230,135,149,103,81,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,26,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,57,103,153,240,47,220,230,57,12,135,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,239,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,57,103,153,240,47,220,230,57,12,135,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,125,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,151,81,135,12,220,230,220,81,103,240,47,116,236,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,134,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,151,81,135,12,220,230,57,81,103,227,236,236,196,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,53,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,229,81,103,177,81,135,48,81,57,12,218,103,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,8,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,151,81,135,12,220,230,220,81,103,240,47,116,236,30,230,116,12,47,141,250,163,89,250,151,81,135,12,220,230,220,81,103,240,47,116,236,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,90,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,218,236,141,105,218,144,151,81,135,12,220,230,220,81,103,240,47,116,236,154,67,30,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,237,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,48,81,105,151,254,177,117,48,254,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,213,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,128,105,141,196,105,220,81,230,218,236,105,151,81,151,230,151,81,135,12,220,230,220,81,103,240,47,116,236,144,48,81,105,151,254,177,117,48,254,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,67,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,128,105,141,196,105,220,81,230,218,236,105,151,81,151,230,151,81,135,12,220,230,220,81,103,240,47,116,236,144,229,81,103,177,81,135,48,81,57,12,218,103,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,26,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,48,81,105,151,254,177,117,48,254,144,103,236,47,12,168,135,81,153,144,57,103,153,240,47,220,230,57,12,135,144,103,236,57,103,153,240,47,220,144,151,81,135,12,220,230,220,81,103,240,47,116,236,30,154,67,67,154,67,90,30,154,67,53,30,250,164,250,125,30,250,163,89,250,239,237,53,8,237,125,213,90,239,53,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,239,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,48,81,105,151,254,177,117,48,254,144,103,236,47,12,168,135,81,153,144,57,103,153,240,47,220,230,57,12,135,144,103,236,57,103,153,240,47,220,144,218,236,105,151,30,154,67,67,154,67,90,30,154,67,53,30,250,164,250,125,30,250,163,89,250,239,237,53,90,213,8,67,237,213,90,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,125,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,48,81,105,151,254,177,117,48,254,144,103,236,47,12,168,135,81,153,144,57,103,153,240,47,220,230,57,12,135,144,103,236,57,103,153,240,47,220,144,218,236,105,151,116,240,218,81,30,154,67,67,154,67,90,30,154,67,53,30,250,164,250,125,30,250,163,89,250,67,125,67,237,26,67,67,67,213,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,134,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,48,81,105,151,254,177,117,48,254,144,103,236,47,12,168,135,81,153,144,57,103,153,240,47,220,230,57,12,135,144,103,236,57,103,153,240,47,220,144,151,236,116,240,218,81,30,154,67,67,154,67,90,30,154,67,53,30,250,164,250,125,30,250,163,89,250,26,239,239,26,134,90,8,125,213,239,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,53,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,218,236,105,151,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,8,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,229,81,103,171,57,81,153,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,90,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,103,105,135,218,81,230,141,236,47,141,105,103,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,67,237,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,18,162,141,153,240,128,103,233,236,151,81,250,163,89,250,26,53,26,134,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,26,213,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,9,235,43,225,171,162,180,48,250,105,47,151,250,47,236,103,250,233,78,236,78,43,105,141,196,81,103,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,26,67,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,9,235,43,225,171,162,180,48,250,105,47,151,250,103,149,128,81,144,233,78,236,78,43,105,141,196,81,103,30,250,163,89,250,172,12,57,81,153,151,105,103,105,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,26,26,30,250,153,81,103,12,153,47,250,81,47,151,73,250,250,250,250,240,116,250,151,81,135,12,220,230,220,81,103,240,47,116,236,144,236,57,230,220,81,103,81,47,35,30,230,199,227,105,103,250,163,89,250,172,233,172,250,103,227,81,47,250,128,153,240,47,103,144,172,180,153,153,236,153,250,240,47,250,78,236,105,151,240,47,220,71,172,230,230,26,239,30,250,153,81,103,12,153,47,250,81,47,151,73,73,250,250,250,250,218,236,141,105,218,250,233,12,153,43,236,57,250,89,213,73,250,250,250,250,218,236,141,105,218,250,136,81,149,43,236,57,250,89,250,213,73,250,250,250,250,218,236,141,105,218,250,136,81,149,250,89,250,172,57,116,105,57,151,116,105,151,57,220,151,116,220,105,151,57,116,172,73,250,250,250,250,218,236,141,105,218,250,233,236,151,81,250,89,250,225,229,230,162,141,153,240,128,103,233,236,151,81,73,250,250,250,250,218,236,141,105,218,250,162,103,153,240,47,220,198,149,103,81,250,89,250,57,103,153,240,47,220,230,135,149,103,81,73,250,250,250,250,218,236,141,105,218,250,162,103,153,240,47,220,233,227,105,153,250,89,250,57,103,153,240,47,220,230,141,227,105,153,73,250,250,250,250,218,236,141,105,218,250,162,103,153,240,47,220,162,12,135,250,89,250,57,103,153,240,47,220,230,57,12,135,73,250,250,250,250,218,236,141,105,218,250,156,236,78,236,105,151,250,89,250,116,12,47,141,103,240,236,47,144,30,73,250,250,250,250,250,250,250,250,136,81,149,43,236,57,250,89,250,136,81,149,43,236,57,250,164,250,67,73,250,250,250,250,250,250,250,250,240,116,250,136,81,149,43,236,57,250,228,250,18,136,81,149,250,103,227,81,47,250,136,81,149,43,236,57,250,89,250,67,250,81,47,151,73,250,250,250,250,250,250,250,250,233,12,153,43,236,57,250,89,250,233,12,153,43,236,57,250,164,250,67,73,250,250,250,250,250,250,250,250,240,116,250,233,12,153,43,236,57,250,228,250,18,233,236,151,81,250,103,227,81,47,73,250,250,250,250,250,250,250,250,250,250,250,250,153,81,103,12,153,47,250,172,172,73,250,250,250,250,250,250,250,250,81,218,57,81,73,250,250,250,250,250,250,250,250,250,250,250,250,218,236,141,105,218,250,170,81,199,198,149,103,81,250,89,250,162,103,153,240,47,220,198,149,103,81,144,162,103,153,240,47,220,162,12,135,144,233,236,151,81,154,233,12,153,43,236,57,154,233,12,153,43,236,57,30,30,250,215,250,162,103,153,240,47,220,198,149,103,81,144,162,103,153,240,47,220,162,12,135,144,136,81,149,154,136,81,149,43,236,57,154,136,81,149,43,236,57,30,30,73,250,250,250,250,250,250,250,250,250,250,250,250,240,116,250,170,81,199,198,149,103,81,250,69,250,213,250,103,227,81,47,250,170,81,199,198,149,103,81,250,89,250,170,81,199,198,149,103,81,250,164,250,26,134,53,250,81,47,151,73,250,250,250,250,250,250,250,250,250,250,250,250,153,81,103,12,153,47,250,162,103,153,240,47,220,233,227,105,153,144,170,81,199,198,149,103,81,30,73,250,250,250,250,250,250,250,250,81,47,151,73,250,250,250,250,81,47,151,73,250,250,250,250,218,236,141,105,218,250,225,180,170,9,250,89,250,225,229,230,162,141,153,240,128,103,180,170,9,250,236,153,250,97,225,229,250,89,250,225,229,115,73,250,250,250,250,218,236,105,151,144,156,236,78,236,105,151,154,47,240,218,154,172,135,103,172,154,225,180,170,9,30,144,30,73,250,250,250,250,156,236,78,236,105,151,250,89,250,116,12,47,141,103,240,236,47,144,30,250,81,47,151,73,20,211,103,147,109,60,232,248,235,82,16,42,225,100,135,243,240,45,158,15,90,7,187,221,28,51,129,219,229,39,247,55,15,86,202,106,148,154,41,27,91,2,205,97,29,25,126,253,109,12,99,37,213,193,152,148,92,15,38,188,39,45,12,104,22,217,63,150,129,123,85,30,217,188,188,145,81,196,82,31,224,255,251,187,7,115,197,128,254,60,228,153,254,105,255,202,184,238,17,85,148,134,196,239,102,183,112,28,120,145,193,181,242,14,213,212,165,42,200,11,94,139,156,112,29,42,115,225,49,194,239,210,227,4,77,122,137,238,210,168,17,240,224,202,41,233,20,151,250,251,4,155,47,70,203,47,70,240,58,7,34,109,16,207,252,240,110,54,156,72,45,76,207,135,96,75,139,40,44,119,78,94,196,27,100,118,79,84,206,94,21,213,79,214,114,15,234,2,192,5,164,188,195,110,59,104,199,234,8,120,111,228,92,243,143,204,51,221,248,147,115,41,164,108,157,84,18,35,101,13,6,190,182,121,51,190,212,132,245,242,73,29,215,181,225,46,93,62,68,70,107,142,36,206,1,255})


--if not VIP_USER then return end


----------------------------------------------------
-- DURING LOADING (this will call the function ActivateScript() if user is authed)
----------------------------------------------------

local changelogLines = {
    "Silent Brand 2.1",
		"Improved W Casting",
		"Improved Safteynet",
		"Improved Ult minion to kill enemy logic",
		"Added walk to midlane if past 30 seconds - True by default",
    "",
    "Don't be afraid to leave feedback. All feedback is good feedback",
    "Thanks for Using Silent Brand by Tivia!"

}



-- Champion vars
local enemyChamps, allyChamps = GetEnemyHeroes(), GetAllyHeroes()
local enemyCount
local allyCount


-- Other vars
local iSlot
local kill = {}
local lasttime={}
local lastTime = 0
local lastpos={}
local VP = nil
local champTable = {
    ["Ahri"] = true,
    ["Akali"] = true,
    ["Anivia"] = true,
    ["Annie"] = true,
    ["Azir"] = true,
    ["Cassiopia"] = true,
    ["Fiddlesticks"] = true,
    ["Heimerdinger"] = true,
    ["Karma"] = true,
    ["Karthus"] = true,
    ["Lissandra"] = true,
    ["LeBlanc"] = true,
    ["Lux"] = true,
    ["Malzahar"] = true,
    ["Morgana"] = true,
    ["Orianna"] = true,
    ["Ryze"] = true,
    ["Swain"] = true,
    ["Syndra"] = true,
    ["TwistedFate"] = true,
    ["Veigar"] = true,
    ["Viktor"] = true,
    ["Ziggs"] = true,
    ["Zyra"] = true,
    ["Fizz"] = true,
    ["Kassadin"] = true,
    ["Zed"] = true,
    ["Yasuo"] = true,
    ["Talon"] = true,
    ["Katarina"] = true,


}


function OnLoad()
    local scriptName = "SilentBrand"
    local thisScript = "xt" -- same of config.php and database.sql
    local basehost = 'justhin.nl'
    local authpath = "/authServer/"
    _G.SilentBrandVersion = 2.1

    local HWID = Base64Encode(tostring(os.getenv("PROCESSOR_REVISION")..os.getenv("USERNAME")..os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")))
    local myUs = GetUser():lower()


    SxWebResult(basehost,authpath..'auth.php?a='..HWID..'&b='..Base64Encode(myUs)..'&c=1&p=0&v='.._G.SilentBrandVersion..'&d='..thisScript,
        function(result)
           -- print(result)
            if result == "AUTH_OK" then
                ActivateScript()
                SxWebResult(basehost, authpath..'message.php?user='..myUs..'&ver='.._G.SilentBrandVersion..'&status=ok&script='..thisScript, function(result) PrintChat(result) end)
            elseif not VIP_USER then
                PrintChat("<font color=\"#FF794C\"><b>"..scriptName..": </b></font><font color=\"#990000\">Sorry, free users can't use this script due to new paid scripts rules</font>")
            elseif result == "AUTH_TRIAL" then
                ActivateScript()
                SxWebResult(basehost, authpath..'message.php?user='..myUs..'&ver='.._G.SilentBrandVersion..'&status=trial&script='..thisScript, function(result) PrintChat(result) end)
            elseif result == "AUTH_EXPIRED" then
                SxWebResult(basehost, authpath..'message.php?user='..myUs..'&ver='.._G.SilentBrandVersion..'&status=no&script='..thisScript, function(result) PrintChat(result) end)
            elseif result == "AUTH_FAIL" then
                SxWebResult(basehost, authpath..'message.php?user='..myUs..'&ver='.._G.SilentBrandVersion..'&status=fail&script='..thisScript, function(result) PrintChat(result) end)
            elseif result == "AUTH_BANNED" then
                SxWebResult(basehost, authpath..'message.php?user='..myUs..'&ver='.._G.SilentBrandVersion..'&status=banned&script='..thisScript, function(result) PrintChat(result) end)
            end
            --[[
            if result == "AUTH_TRIAL" then
                    print(scriptName, "Welcome back to Silent Brand, " ..GetUser()..".")
                else
                    --local time = 3600*78
                            local time = 1*1
                    if IsTrial(time) then
                        local hours = math.floor(GetTrialTime(time)/3600)
                        local minutes = math.floor((GetTrialTime(time) - hours * 3600)/60)
                        print(scriptName, ": Welcome to Silent Brand, "..GetUser()..", your trial will expire in "..tostring(hours).. " hours, "..tostring(minutes).." minutes.")
                    else
                        print(scriptName, ": Welcome to Silent Brand, "..GetUser()..", your trial have expired. ")
                        return
                    end
                end]]--
        end

    )

end
function ActivateScript()
    enemyCount = #enemyChamps
    allyCount = #allyChamps

    skillQ =
    {
	
        range = 1080,
				delay = 500,
				radius = 60,
				speed = 1.60,
        dmg = function() return (40 + (GetSpellData(0).level*40) + (myHero.ap*0.65)) end
				
    }
	
	skillW =
    {
        range = 900,
				delay = .625,
				radius = 275,
				speed = math.huge,
        dmg = function() return (35 + (GetSpellData(0).level*35) + (myHero.ap*0.55)) end
    }
	
	skillE =
    {
        range = 625,
        dmg = function() return (35 + (GetSpellData(0).level*35) + (myHero.ap*0.55)) end
    }
	
	skillR =
    {
        range = 750,
        dmg = function() return (50 + (GetSpellData(0).level*100) + (myHero.ap*0.50)) end
    }

    Checks()
    _G.oldDrawCircle = rawget(_G, 'DrawCircle')
    _G.DrawCircle = DrawCircle2
    VP = VPrediction()
	UPL = UPL()
	
	UPL:AddSpell(_Q, { speed = 1200, delay = 0.25, range = 1080, width = 75, collision = true, aoe = false, type = "linear" })
	UPL:AddSpell(_W, { speed = math.huge, delay = 0.625, range = 875, width = 240, collision = false, aoe = true, type = "circular" })
	
    Config = scriptConfig("Silent Brand", "HereComesTheMoney")
	Config:addParam("walktomidd", "Walk to MidLane at 00:30", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("A"))
    Config:addSubMenu("Keybindings", "keybindings")
    Config:addSubMenu("Draw Settings", "Draw")
    Config:addSubMenu("Matchups", "Matchups")
    Config:addSubMenu("Changelog", "Changelog")
    Config:addSubMenu("Interrupt Settings",  "interrupt")
	Config:addSubMenu("Orbwalker Settings", "Orbwalking")
	UPL:AddToMenu(Config)
	Config:addParam("hc", "Accuracy:", SCRIPT_PARAM_SLICE, 2,0,3,1)
    Config.keybindings:addSubMenu("Combo Options", "combo1")
	
    Config.keybindings.combo1:addParam("combo", "Combo!", SCRIPT_PARAM_ONKEYDOWN, false, 32)
    Config.keybindings.combo1:addParam("useq", "Save Q for stun/ks", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("J"))
    Config.keybindings.combo1:addParam("qinfo", "If toggled on, saves Q for stun and KS else Always cast", SCRIPT_PARAM_INFO, "")
    -- Toggled on it save Q for stun and KS. Toggled off it fire Q whenever it's off CD.
    Config.keybindings.combo1:addParam("spellorder",  "Combo Order:", SCRIPT_PARAM_LIST, 1, { "Always EWQ", "Always WEQ", "Combo with Range"})
    Config.keybindings.combo1:addParam("ult", "Ult when killable", SCRIPT_PARAM_ONOFF, true)
    Config.keybindings.combo1:addParam("ultcount", "Ult amount of enemys", SCRIPT_PARAM_SLICE, 3, 0, 5, 0)
    Config.keybindings.combo1:addParam("ultminion", "Ult enemy near minion for kill", SCRIPT_PARAM_ONOFF, true)
    Config.keybindings.combo1:addParam("Mana", "Combo Mana Manager %",4,50,1,100,2)

    Config.keybindings:addSubMenu("Harass Options", "harass")

    Config.keybindings.harass:addParam("harasstoggle", "Toggle Harass", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("T"))
    Config.keybindings.harass:addParam("harasskeydown", "Harass key down", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
    Config.keybindings.harass:addParam("qharass", "Harass with Q", SCRIPT_PARAM_ONOFF, false)
    Config.keybindings.harass:addParam("wharass", "Harass with W", SCRIPT_PARAM_ONOFF, true)
    Config.keybindings.harass:addParam("eharass", "Harass with E", SCRIPT_PARAM_ONOFF, true)
    Config.keybindings.harass:addParam("Mana3", "Harass Mana Manager %",4,50,1,100,2)
    Config.keybindings.harass:addParam("info200", "If multiple selected, will cast together",  SCRIPT_PARAM_INFO, "")

    Config.keybindings:addSubMenu("Killsteal Options", "ks")

    Config.keybindings.ks:addParam("qks", "KS with Q", SCRIPT_PARAM_ONOFF, true)
    Config.keybindings.ks:addParam("wks", "KS with W", SCRIPT_PARAM_ONOFF, true)
    Config.keybindings.ks:addParam("eks", "KS with E", SCRIPT_PARAM_ONOFF, true)
    Config.keybindings.ks:addParam("RKS", "KS with R", SCRIPT_PARAM_ONOFF, true)
    Config.keybindings.ks:addParam("igniteks", "KS with ignite", SCRIPT_PARAM_ONOFF, true)
    --> Ignite
    if myHero:GetSpellData(SUMMONER_1).name:lower():find("summonerdot") then iSlot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("summonerdot") then iSlot = SUMMONER_2
    else iSlot = nil
    end


    Config.keybindings:addSubMenu("Waveclear Options", "waveclear")
    Config.keybindings.waveclear:addParam("WaveClear", "WaveClear Minions", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
    Config.keybindings.waveclear:addParam("qclear", "Waveclear with Q", SCRIPT_PARAM_ONOFF, false)
    Config.keybindings.waveclear:addParam("wclear", "Waveclear with W", SCRIPT_PARAM_ONOFF, true)
    Config.keybindings.waveclear:addParam("wclearnumber", "W on:", SCRIPT_PARAM_LIST, 2, { "2 Minions", "3 Minions", "4 Minions", "5 Minions", "6+ Minions" })
    Config.keybindings.waveclear:addParam("eclear", "Waveclear with E", SCRIPT_PARAM_ONOFF, true)

    Config.keybindings.waveclear:addParam("Mana2", "WaveClear Mana Manager %",4,25,1,100,2)
    Config.keybindings.waveclear:addParam("info124234", "Notice: Uses all spells", SCRIPT_PARAM_INFO, "")

    Config.keybindings:addParam("safeattack", "Stun if enemy in safe range", SCRIPT_PARAM_ONOFF, true)

    Config.keybindings:addParam("saferange", "Safe Range:",4,50,150,900,2)

    Config.Changelog:addParam("Changelog", "Changelog", SCRIPT_PARAM_ONOFF, true)

    Config.Draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("Lfc", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("CL", "Lag Free Circles Quality", 4, 75, 75, 2000, 0)
    Config.Draw:addParam("Width", "Lag Free Circles Width", 4, 2, 1, 10, 0)
       Config.Draw:addParam("info987900", "Drawing on HP bars", SCRIPT_PARAM_INFO, "")
		Config.Draw:addParam("drawQ2", "Draw Q Damage", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawW2", "Draw W Damage", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawE2", "Draw E Damage", SCRIPT_PARAM_ONOFF, true)
		Config.Draw:addParam("drawR2", "Draw R Damage", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawP", "Draw Passive Damage", SCRIPT_PARAM_ONOFF, true)
    Config.Draw:addParam("drawI", "Draw Ignite damage", SCRIPT_PARAM_ONOFF, true)
		Config.Draw:addParam("drawCombo", "Draw 'Combo'", SCRIPT_PARAM_ONOFF, true)


    Config.interrupt:addParam("interruptinterrupt", "Interrupt Spells", SCRIPT_PARAM_ONOFF, true)

    if #InterruptGame > 0 then
        Config.interrupt:addParam("info24318", "Interrupt", SCRIPT_PARAM_INFO, "")
        for i, v in pairs(InterruptGame) do
            Config.interrupt:addParam(v.spell, v.name.."-"..v.spell, SCRIPT_PARAM_ONOFF, true)
        end
    else
        Config.interrupt:addParam("info113131", "No supported spells found", SCRIPT_PARAM_INFO, "")
    end

    enemyMinions = minionManager(MINION_ENEMY, 900, MyHero, MINION_SORT_HEALTH_ASC)
    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, skillQ.range, DAMAGE_MAGIC, true)
    Config:addTS(ts)
            for i = 1, enemyCount do
			local enemy = enemyChamps[i]
            if enemy.charName == "Ahri" then
                Config.Matchups:addParam("info1", "Dificulty: 7.5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info2", "Bully her early", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info3", "Ask for early ganks", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info4", "Dont fight her ult", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Akali" then
                Config.Matchups:addParam("info5", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info6", "You win early", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info7", "Fight near enemy minion", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info8", "Ignite after stun", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Anivia" then
                Config.Matchups:addParam("info9", "Dificulty: 8/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info10", "Kill her early", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info11", "If lane even, dont fight", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Annie" then
                Config.Matchups:addParam("info12", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info13", "Harass from max Range", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info14", "Turn on stun at safe range", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info15", "Try bouncing ult on tibbers", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Azir" then
                Config.Matchups:addParam("info16", "Dificulty: 4/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info17", "He lacks mobility", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info18", "You win if pressure him", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Cassiopia" then
                Config.Matchups:addParam("info19", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info20", "She has better dps", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info21", "Rush Magic Pen", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info22", "Turn on evadeee", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "FiddleSticks" then
                Config.Matchups:addParam("info23", "Dificulty: 8/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info24", "Fight him b4 he levels fear", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info25", "Use your full burst", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info26", "when his fear is down", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info27", "Build MR", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Heimerdinger" then
                Config.Matchups:addParam("info28", "Dificulty: 9/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info29", "Beg for early gank", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info30", "Rush Deathcap or Grail", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info31", "Stack Potions", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Karma" then
                Config.Matchups:addParam("info32", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info33", "Same Range but you outdamage", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info34", "Rush Magic Pen/Zhonyahs", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info35", "Rylies to slow her", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Karthus" then
                Config.Matchups:addParam("info36", "Dificulty: 2/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info37", "Turn on Evadeee", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info38", "Rush Magic Pen/Zhonyahs", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info39", "Fight him ALWAYS", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Lissandra" then
                Config.Matchups:addParam("info40", "Dificulty: 7/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info41", "Stay away from your minions", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info42", "Rush Magic Pen", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info43", "Get Close after she Q's", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "LeBlanc" then
                Config.Matchups:addParam("info44", "Dificulty: 4/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info45", "Try to fight her in melee range", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info46", "If her helath is >50, All In her", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info47", "x2 Dorans,Into Grail, Into Deathcap", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Lux" then
                Config.Matchups:addParam("info48", "Dificulty: 6/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info49", "Try to stun before she can shield", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info50", "If she hits you with spells", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info51", "Do not let her proc passive", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info52", "Rush Magic Pen, take Barrier/Heal", SCRIPT_PARAM_INFO,"")
            end
            if enemy.charName == "Malzahar" then
                Config.Matchups:addParam("info53", "Dificulty: 9/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info54", "Rush x3 dorans and flask", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info55", "Dont be afraid to heal/barrier his dmg", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info56", "Try to avoid Fighting him", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Morgana" then
                Config.Matchups:addParam("info57", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info58", "Set Evadeee to dodge her Q", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info59", "Punish her when she auto attacks", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info60", "Zhonyahs Hourglass stops her ult. Build it", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info61", "Rush Magic Pen Boots into big item", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Orianna" then
                Config.Matchups:addParam("info62", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info63", "Once she casts Q, Go all in.", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info64", "Push her to tower", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info65", "Go Magic Pen Boots, Haunting Guise, Deathcap", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Ryze" then
                Config.Matchups:addParam("info66", "Dificulty: 4/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info67", "Same damage, you outrange him", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info68", "If your stun misses, back up", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info69", "Ignite him once he ults", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info70", "Magic Pen Boots, Haunting Guise and Rylies", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Swain" then
                Config.Matchups:addParam("info71", "Dificulty: 10/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info72", "Make sure Evadeee dodges his W.", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Syndra" then
                Config.Matchups:addParam("info73", "Dificulty: 7/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info74", "You can burst her 100-0", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info75", "Dodge Q's and the lane is yours", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info76", "Magic Pen and Rylies are your bestfriend", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "TwistedFate" then
                Config.Matchups:addParam("info77", "Dificulty: 3/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info78", "Fight him when he blue cards", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info79", "Run if he goldcards", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info80", "Build Tenacity boots and magic pen", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info81", "You win hard after 6", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Veigar" then
                Config.Matchups:addParam("info82", "Dificulty: 3/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info83", "Zone/Fight him when his Q is down", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info84", "Have to build Utility because his ult", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info85", "Merc Treads, Athenes Grail, Rylies, Abby Scepter", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Viktor" then
                Config.Matchups:addParam("info86", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info87", "Punish him when he gets in aa range", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info88", "Zone him when his E is down", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info89", "Build Athenes, Rylies, Haunting Guise", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Ziggs" then
                Config.Matchups:addParam("info90", "Dificulty: 8/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info91", "Rush boots early followed by chalice", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info92", "If you get early ganks, lane is yours easy", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Zyra" then
                Config.Matchups:addParam("info93", "Dificulty: 9/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info94", "Ask your jungler to camp mid.", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Fizz" then
                Config.Matchups:addParam("info95", "Dificulty: 9999/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info96", "Max E", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info97", "Build RoA, Zhonyahs, Rylies, Abyssal Scepter", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Kassadin" then
                Config.Matchups:addParam("info98", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info99", "Early game is yours", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info100", "Shove him to tower so he cant farm", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info101", "Don't 1v1 him in melee range or you lose", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Zed" then
                Config.Matchups:addParam("info102", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info103", "Combo him when he tries to auto minions", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Yasuo" then
                Config.Matchups:addParam("info104", "Dificulty: 5/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info105", "Stay away from him at level one", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info106", "Auto him when his passive is up", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info107", "Rush Haunting Guise, Magic pen boots", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info108", "Try to build Zhonaysh and Rylai's ASAP", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Talon" then
                Config.Matchups:addParam("info109", "Dificulty: 7/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info110", "You DESTROY him early", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info111", "After 6 Buy a pink ward/trinket", SCRIPT_PARAM_INFO, "")
            end
            if enemy.charName == "Katarina" then
                Config.Matchups:addParam("info112", "Dificulty: 7/10", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info113", "This matchup is all about positioning", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info114", "Make Good use of Saftey-Net", SCRIPT_PARAM_INFO, "")
                Config.Matchups:addParam("info115", "Athenes and Rylai's are your friends", SCRIPT_PARAM_INFO, "")
            end
            if champTable[enemy.charName] == nil then
                Config.Matchups:addParam("info116", "No information on this matchup avaliable.", SCRIPT_PARAM_INFO, "")
            end

    end


    AddDrawCallback(function() MyOnDraw() end)
    AddProcessSpellCallback(function(unit, spell) MyOnProcessSpell(unit,spell) end)
    AddTickCallback(function() MyOnTick() end)
    --AddGetSlotCallback(function() GetSlotItem() end)
    --AddFindBushCallback(function(x0, y0, z0, maxRadius, precision) FindBush(x0, y0, z0, maxRadius, precision) end)
    --AddOnWndMsgCallback(function(msg, key) OnWndMsg(msg, key) end)
    --AddGetAbilityFrameCallback(function(unit) GetAbilityFramePos(unit) end)
    --AddOverHeadHudCallback(function(unit, framePos, Textheight, newDamage, str, color) DrawOverheadHUD(unit, framePos, Textheight, newDamage, str, color) end)
    --AddTARGBCallback(function(colorTable) TARGB(colorTable) end)
    --AddCountEnemysInRangeCallback(function(range) CountEnemyHeroInRange(range) end)
    --AddUnitBuffCallback(function(unit, buffName) UnitHaveBuff(unit, buffName) end)
    --AddHaveBuffCallback(function(unit, buffname) HaveBuff(unit, buffname) end)


    --findClosestEnemy()
    --HaveBuff()
    --UnitHaveBuff()
    CountEnemyHeroInRange()
    drawDamage()
    --	DrawOverheadHUD()
    --GetAbilityFramePos()
    --TARGB()
    --OnWndMsg()

    DrawChangeLog()
    --bushfind()
    --ItemS()
    --OnTick()
    --OnDraw()
    SmartCombo()
    Harass()
    WaveClear()
    --Damage()
    SafeStun()
    DelayAction(Checks, 5)
    Checks()
    CastQ()
    CastW()
    CastE()
    CastR()
	ignite()
    --open_url("google.com")
    AutoUlt()
    SpellStopper()
 DelayAction(CheckOrbwalk, 8)
ManaTable()
end

 function CheckOrbwalk()
	 if _G.Reborn_Loaded and not _G.Reborn_Initialised then
        DelayAction(CheckOrbwalk, 1)
    elseif _G.Reborn_Initialised then
        sacused = true
		Config.Orbwalking:addParam("info11","SAC Detected", SCRIPT_PARAM_INFO, "")
    elseif _G.MMA_Loaded then
		Config.Orbwalking:addParam("info11","MMA Detected", SCRIPT_PARAM_INFO, "")
		mmaused = true
	else
		require "SxOrbWalk"
		SxOrb:LoadToMenu(Config.Orbwalking, false) 
		sxorbused = true
		SxOrb:RegisterAfterAttackCallback(MyAfterAttack)
		DelayAction(function()		
			if SxOrb.Version < 2.3 then
				Print("Your SxOrbWalk library is outdated, please get the latest version!")
			end
		end, 5)
	end
end
 

function MyOnProcessSpell(unit, spell)
    if not unit or not unit.valid then return end
    if not QREADY then return end

    if #InterruptGame > 0 then
        for i, v in pairs(InterruptGame) do
            if (spell.name == v.spell) and (unit.team ~= myHero.team) and Config.interrupt[v.spell] then
                if GetDistance(unit) < skillW.range and Config.interrupt.interruptinterrupt then
                    CastSpell(_W, unit.x, unit.z)
                    CastSpell(_E, unit)
                    CastQ()
                end
            end
        end
    end
end
function AutoUlt()
    for i = 1, enemyCount do
        local unit = enemyChamps[i]
        if GetDistance(unit) < 750 then
            if RREADY and CountEnemyHeroInRange(850) >= Config.keybindings.combo1.ultcount then
                CastSpell(_R, unit)
            end
        end
    end
end
--[[
-- Attempts to open a given URL in the system default browser, regardless of Operating System.
local open_cmd -- this needs to stay outside the function, or it'll re-sniff every time...
function open_url(url)
    if not open_cmd then
        if package.config:sub(1,1) == '\\' then -- windows
            open_cmd = function(url)
                -- Should work on anything since (and including) win'95
                os.execute(string.format('start "%s"', url))
            end
        end
    end
    open_cmd(url)
end]]--
function OnWndMsg(msg, key)
    mouse = WorldToScreen(mousePos)

    -- Mouse hover withing position of exit button (changelog)
    if showChangelog and mouse.x >= ((WINDOW_W / 2) + 150) and mouse.x <= ((WINDOW_W / 2) + 200) and mouse.y >= ((WINDOW_H / 5) + 1) and mouse.y <= ((WINDOW_H / 5) + 24) then
        if key == 1 and msg == WM_LBUTTONDOWN then -- closing changelog
        showChangelog = false
        if(Config.Changelog.Changelog ~= nil) then
            Config.Changelog.Changelog = false
        end
        end
    end
end

function DrawOverheadHUD(unit, framePos, Textheight, newDamage, str, color)
    local barPos = Point(framePos.x, framePos.y - 18)
    healthMissing = (unit.maxHealth - unit.health)
    offset = -105 * (newDamage/unit.maxHealth + healthMissing/unit.maxHealth)
    barPos = Point(framePos.x + 105, framePos.y - 26)

    if offset <= (-105) then
        DrawText(str, 40, barPos.x + - 100, barPos.y - 23, color)
        DrawText("Kill the bitch", 20, barPos.x + - 100, barPos.y - 40, color)
    else
        DrawText(str, 14, barPos.x + offset + 5, (barPos.y - 15) - Textheight , color)
        DrawRectangle(barPos.x + offset - 1, barPos.y - Textheight, 2, 15 + Textheight, color)
        DrawRectangle(barPos.x + offset - 1, barPos.y - 2 - Textheight, 15, 2, color)
    end

end

function GetAbilityFramePos(unit)
    local barPos = GetUnitHPBarPos(unit)
    local barOffset = GetUnitHPBarOffset(unit)

    do -- For some reason the x offset never exists
    local t = {
        ["Darius"] = -0.05,
        ["Renekton"] = -0.05,
        ["Sion"] = -0.05,
        ["Thresh"] = 0.03,
    }
    barOffset.x = t[unit.charName] or 0
    end

    return Point(barPos.x - 69 + barOffset.x * 150, barPos.y + barOffset.y * 50 + 12.5)
end

function TARGB(colorTable)
    do return ARGB(colorTable[1], colorTable[2], colorTable[3], colorTable[4])
    end
end

function HaveBuff(unit, buffname)
    for i = 1, unit.buffCount do
        local buff = unit:getBuff(i)
        if buff and buff.valid and buff.name ~= nil and buff.name:lower():find(buffname) and buff.endT > GetInGameTimer() then
            return true
        end
    end
    return false
end

function UnitHaveBuff(unit, buffName)
    if unit and buffName and unit.buffCount then
        for i = 1, unit.buffCount do
            local buff = unit:getBuff(i)
            if buff and buff.valid and buff.startT <= GetGameTimer() and buff.endT >= GetGameTimer() and buff.name ~= nil and (buff.name:find(buffName) or buffName:find(buff.name) or buffName:lower() == buff.name:lower()) then
                return true
            end
        end
    end
    return false
end

function CountEnemyHeroInRange(range)
    local enemyInRange = 0
    for i = 1, heroManager.iCount, 1 do
        local enemyheros = heroManager:getHero(i)
        if enemyheros.valid and enemyheros.visible and enemyheros.dead == false and enemyheros.team ~= myHero.team and GetDistance(enemyheros) <= 1050 then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end



--DelayAction(CheckOrbwalk, 4)

function MyOnTick()
    Checks()
    enemyMinions:update()
    WaveClear()
    MinionR()
	ignite()
	if Config.walktomidd then
		--if InFountain() and GetInGameTimer() < 30 then
			--DrawText3D(myHero.x, myHero.y, myHero.z,radius+125, 1, RGB(255, 255, 255)) 
			--DrawText3D(str,myHero.x,myHero.y,myHero.z,16,RGB(255, 255, 255))
		--end
		if InFountain() and GetInGameTimer() < 30 and GetInGameTimer() > 33 then myHero:MoveTo(5994, 6144) end 
	end
    if Config.Draw.Lfc then
        _G.DrawCircle = DrawCircle2
    else
        _G.DrawCircle = _G.oldDrawCircle
    end

    if Config.keybindings.safeattack then
        SafeStun()
    end
    if Config.keybindings.combo1.combo then
        SmartCombo()
    end
    if Config.keybindings.combo1.ult then
        CastR()
    end
    if Config.keybindings.WaveClear then
        WaveClear()
    end
    if Config.keybindings.harass.harasstoggle then
        Harass()
    end
    if Config.keybindings.ks.qks then
        if not QREADY then return end
        for i = 1, enemyCount do
            local unit = enemyChamps[i]

            if GetDistance(unit) < skillQ.range then
                local damage = myHero:CalcMagicDamage(unit, skillQ.dmg()) - 5
                if damage > unit.health then CastQ() end
            end
        end
    end
    if Config.keybindings.ks.wks then
        if  not WREADY then return end
            for i = 1, enemyCount do
            local enemy = enemyChamps[i]
                if GetDistance(enemy, myHero) < skillW.range then
                    local damageW = function() return (30 + (GetSpellData(0).level*45) + (myHero.ap*0.6)) end
                    newDamage = myHero:CalcMagicDamage(enemy, damageW()) - 5
                    if newDamage > enemy.health then
                        CastW()
                    end
                end
            end

    end
    if Config.keybindings.ks.eks then
        if not EREADY then return end
            for i = 1, enemyCount do
            local enemy = enemyChamps[i]
                if GetDistance(enemy, myHero) < skillE.range then
                    local damageE = function() return (35 + (GetSpellData(0).level*35) + (myHero.ap*0.55)) end
                    newDamage = myHero:CalcMagicDamage(enemy, damageE()) - 5
                    if newDamage > enemy.health then
                        CastE()
                    end
                end
            end
    end
    if Config.keybindings.ks.RKS then
        CastR()
    end
	
 

end
function ignite()
    if Config.keybindings.ks.igniteks then
        local iDmg = 0
        if iSlot ~= nil and myHero:CanUseSpell(iSlot) == READY then
            for i = 1, heroManager.iCount, 1 do
                local target = heroManager:getHero(i)
                if ValidTarget(target) then
                    iDmg = 50 + 20 * myHero.level
                    if target ~= nil and target.team ~= myHero.team and not target.dead and target.visible and GetDistance(target) < 600 and target.health < iDmg  then
                        CastSpell(iSlot, target)
                    end
                end
            end
        end
    end
	end

function round(x)
  return x and ( x >=0 and math.floor(x + 0.5) or math.ceil(x-0.5)) or x
end
function MyOnDraw()
--ManaTable()
  --DrawText("Combos left:", 20, 650, 325, 0xFF00FFFF)
 
	--action1 = ("Combos Left:" ..myHero.maxMana/QMANA+WMANA+EMANA)
	--action1 = tostring(action1)

--DrawText(action1, 20, 650, 400, 0xFF00FFFF)
    DrawChangeLog()
    drawDamage()
    Checks()
    if Config.keybindings.safeattack then
        DrawCircle(myHero.x, myHero.y, myHero.z, Config.keybindings.saferange, 0xffff0000)
    end
    if Config.Draw.drawQ and QREADY then
        DrawCircle(myHero.x, myHero.y, myHero.z, skillQ.range, 0xffff00ff)
    end
    if Config.Draw.drawW and WREADY then
        DrawCircle(myHero.x, myHero.y, myHero.z, skillW.range,  0xffff00ff)
    end
    if Config.Draw.drawE and EREADY then
        DrawCircle(myHero.x, myHero.y, myHero.z, skillE.range,  0xffff00ff)
    end

    --[[Check if waypoint is correct
        local Mintargets = 1
    for i, target in pairs(GetEnemyHeroes()) do
        if ValidTarget(target, 900) and not target.dead then
        AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, .500, 240, 900, 2000)
        if nTargets >= Mintargets and GetDistance(AOECastPosition) < 900 then
DrawCircle(AOECastPosition.x, AOECastPosition.y, AOECastPosition.z, 100, 0xFFFF0000)
    end
    end

    end]]--

end

function SmartCombo()
    if myHero.mana / myHero.maxMana > Config.keybindings.combo1.Mana /100 then
        for i = 1, enemyCount do
            local enemy = enemyChamps[i]
                if ValidTarget(enemy) then
                    if Config.keybindings.combo1.spellorder == 1 then
                        if GetDistance(enemy, myHero) < skillE.range then
                            CastE()
                            CastW()
                            if Config.keybindings.combo1.useq then
						
								if UnitHaveBuff(enemy, "brandablaze") then
									CastQ()
								end
                            end
                            if not Config.keybindings.combo1.useq then
								if not UnitHaveBuff(enemy, "brandablaze") then
									CastQ()
								end
                            end
                        end
                    end

                    if Config.keybindings.combo1.spellorder == 2 then
                        --"Always EWQ", "Always WEQ", "Combo with Range"})
                        if GetDistance(enemy, myHero) < skillQ.range then
                            CastW()
                            CastE()
                            if Config.keybindings.combo1.useq then
                                if UnitHaveBuff(enemy, "brandablaze") then
									CastQ()
								end
                            end
                            if not Config.keybindings.combo1.useq then
								if not UnitHaveBuff(enemy, "brandablaze") then
									CastQ()
								end
                            end

                        end
                    end
                    if Config.keybindings.combo1.spellorder == 3 then
                        if GetDistance(enemy, myHero) < skillE.range then
                            CastE()
                            if UnitHaveBuff(enemy, "brandablaze") and Config.keybindings.combo1.useq then
                                CastQ()
                            end
                            if not Config.keybindings.combo1.useq and not UnitHaveBuff(enemy, "brandablaze") then
                                CastQ()
                            end
                            CastW()
                        end
                        if GetDistance(enemy, myHero) < skillQ.range then
                            CastW()
                            if UnitHaveBuff(enemy, "brandablaze") and Config.keybindings.combo1.useq then
                                CastQ()
                            end
							if not UnitHaveBuff(enemy, "brandablaze") and not Config.keybindings.combo1.useq then
                                CastQ()
                            end
                            CastE()
                        end
                    end
					if not Config.keybindings.combo1.useq and not UnitHaveBuff(enemy, "brandablaze") then
						CastQ()
					end
                    --[[
                    if GetDistance(target, myHero) < 1025 then
                        CastW()
                        CastE()
                        CastQ()
                    end			]]--
                end
            end
        end
    end



function Harass()
    enemyMinions:update()
    if Config.keybindings.harass.harasstoggle and myHero.mana / myHero.maxMana > Config.keybindings.harass.Mana3 /100 then
        if Config.keybindings.harass.qharass and not Config.keybindings.harass.wharass and not Config.keybindings.harass.eharass then
            CastQ()
        end
        if Config.keybindings.harass.wharass and not Config.keybindings.harass.qharass and not Config.keybindings.harass.eharass then
            CastW()
        end
        if Config.keybindings.harass.eharass and not Config.keybindings.harass.wharass and not Config.keybindings.harass.qharass then
            CastE()
        end
        if Config.keybindings.harass.qharass and Config.keybindings.harass.wharass and not Config.keybindings.harass.eharass then
            CastW()
            CastQ()
        end
        if Config.keybindings.harass.qharass and Config.keybindings.harass.eharass and not Config.keybindings.harass.wharass then
            CastE()
            CastQ()
        end
        if not Config.keybindings.harass.qharass and Config.keybindings.harass.wharass and Config.keybindings.harass.eharass then
            CastE()
            CastW()
        end

        for i = 1, enemyCount do
        local enemy = enemyChamps[i]
            for index, minion in pairs(enemyMinions.objects) do
                if Config.keybindings.harass.wharass and Config.keybindings.harass.eharass and GetDistance(enemy, myHero) < 925 then
                    if GetDistance(enemy, minion) < 300 and  GetDistance(myHero, minion) < skillE.range then
                        if WREADY then
                            CastSpell(_W, minion.x, minion.z)
                        end
                        if EREADY and UnitHaveBuff(minion, "brandablaze") then
                            CastSpell(_E, minion)
                        end
                    end
                end
            end
        end
    end
    if Config.keybindings.harass.harasskeydown and myHero.mana / myHero.maxMana > Config.keybindings.harass.Mana3 /100 then
        if Config.keybindings.harass.qharass and not Config.keybindings.harass.wharass and not Config.keybindings.harass.eharass then
            CastQ()
        end
        if Config.keybindings.harass.wharass and not Config.keybindings.harass.qharass and not Config.keybindings.harass.eharass then
            CastW()
        end
        if Config.keybindings.harass.eharass and not Config.keybindings.harass.wharass and not Config.keybindings.harass.qharass then
            CastE()
        end
        if Config.keybindings.harass.qharass and Config.keybindings.harass.wharass and not Config.keybindings.harass.eharass then
            CastW()
            CastQ()
        end
        if Config.keybindings.harass.qharass and Config.keybindings.harass.eharass and not Config.keybindings.harass.wharass then
            CastE()
            CastQ()
        end
        if not Config.keybindings.harass.qharass and Config.keybindings.harass.wharass and Config.keybindings.harass.eharass then
            CastE()
            CastW()
        end

        for i = 1, enemyCount do
        local enemy = enemyChamps[i]
            for index, minion in pairs(enemyMinions.objects) do
                if Config.keybindings.harass.wharass and Config.keybindings.harass.eharass and GetDistance(enemy, myHero) < 925 then
                    if GetDistance(enemy, minion) < 300 and GetDistance(myHero, minion) < skillE.range then
                        if WREADY then
                            CastSpell(_W, minion.x, minion.z)
                        end
                        if EREADY and UnitHaveBuff(minion, "brandablaze") then
                            CastSpell(_E, minion)
                        end
                    end
                end
            end
        end
    end
end

function WaveClear()
    enemyMinions:update()
    if Config.keybindings.waveclear.WaveClear and myHero.mana >= myHero.maxMana*Config.keybindings.waveclear.Mana2/100 then

        for index, minion in pairs(enemyMinions.objects) do
            --if minion.health/minion.maxHealth < .40 then
            if Config.keybindings.waveclear.qclear then
                if GetDistance(minion, myHero) <= skillQ.range then
                    if not QREADY then return end
                        CastSpell(_Q, minion.x, minion.z)

                end
            end
            if Config.keybindings.waveclear.wclear then
                if not WREADY then return end
                    local numberofminions = Config.keybindings.waveclear.wclearnumber
                    if ValidTarget(minion, skillW.range) then
                        local AllMinions = SelectUnits(enemyMinions.objects, function(t) return ValidTarget(t) end)
                        AllMinions = GetPredictedPositionsTable(VP, AllMinions, skillW.delay, skillW.radius, skillW.range, skillW.speed, myHero, false)

                        local BestPos, BestHit = GetBestCircularFarmPosition(skillW.range, 450, AllMinions)
                        if BestHit > numberofminions then
                            CastSpell(_W, BestPos.x, BestPos.z)
                            do return end
                        end
                    end

            end

            if Config.keybindings.waveclear.eclear then
                if not EREADY then return end
                    local eDmg = getDmg("E",minion, myHero)
                    if eDmg > minion.health then
                        CastSpell(_E, minion)
                    end
            
            end

            --end
        end--

    end
end




--[[

function UltKillable()

	if RREADY then
		for i, target in pairs(GetEnemyHeroes()) do
			if GetDistance(target, myHero) < 750 then
				local damage = getDmg("R",target, myHero)
				if ValidTarget(target, 750) and damage > target.health then
					CastSpell(_R, target)
				end
			end
		end
		
	end
end
]]--
function SafeStun()
    for i = 1, enemyCount do
            local enemy = enemyChamps[i]
        if ValidTarget(enemy, Config.keybindings.saferange) then


            if Config.keybindings.saferange < skillE.range and GetDistance(enemy, myHero) < Config.keybindings.saferange then
                --print("wcooldown")
                if EREADY then
                    CastE()
                end
                if UnitHaveBuff(enemy, "brandablaze") and QREADY then
                    CastQ()
                end
            end
						            if Config.keybindings.saferange <= skillW.range and GetDistance(enemy, myHero) < Config.keybindings.saferange then
                if WREADY then
                    CastW()
                end
                if UnitHaveBuff(enemy, "brandablaze") and QREADY then
                    CastQ()
                end
            end
        end
    end
end


function Checks()
    QREADY = ((myHero:CanUseSpell(_Q) == READY) or (myHero:GetSpellData(_Q).level > 0 and myHero:GetSpellData(_Q).currentCd <= 0.4))
    WREADY = ((myHero:CanUseSpell(_W) == READY) or (myHero:GetSpellData(_W).level > 0 and myHero:GetSpellData(_W).currentCd <= 0.4))
    EREADY = ((myHero:CanUseSpell(_E) == READY) or (myHero:GetSpellData(_E).level > 0 and myHero:GetSpellData(_E).currentCd <= 0.4))
    RREADY = ((myHero:CanUseSpell(_R) == READY) or (myHero:GetSpellData(_R).level > 0 and myHero:GetSpellData(_R).currentCd <= 0.4))

    --___GetInventorySlotItem	= rawget(_G, "GetInventorySlotItem")
    --_G.GetInventorySlotItem	= GetSlotItem

    for _,c in pairs(GetEnemyHeroes()) do
        lastpos[ c.networkID ] = Vector(c)
    end
    SpellStopper()
end
function CastQ()
    if not QREADY then return end

        for i = 1, enemyCount do
            local enemy = enemyChamps[i]
            if ValidTarget(enemy, skillQ.range) then
			CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, enemy)
				if HitChance >= Config.hc then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
  
                --local CastPosition, HitChance, Position = VP:GetLineCastPosition(enemy, skillQ.delay, skillQ.radius, skillQ.range, skillQ.speed, myHero, true)
                --if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < skillQ.range then
                   -- CastSpell(_Q, CastPosition.x, CastPosition.z)
                --end
            end
        end
end


function CastW()
    if not WREADY then return end

       for i = 1, enemyCount do
        local enemy = enemyChamps[i]
            if ValidTarget(enemy, skillW.range) then

			   CastPosition, HitChance, HeroPosition = UPL:Predict(_W, myHero, enemy)
				if HitChance >= Config.hc then
					CastSpell(_W, CastPosition.x, CastPosition.z)
				end
  
                --local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(enemy, skillW.delay, skillW.radius, skillW.range, skillW.speed, myHero)

               -- if MainTargetHitChance >= 2 and nTargets > 0 then
                --    CastSpell(_W, AOECastPosition.x, AOECastPosition.z)
              --  end
            end

        end
   
end
--[[
function CastW()
    for i, target in pairs(GetEnemyHeroes()) do
		if ValidTarget(target, 900) then
        local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, 0.5, 240, 900, 20, myHero, false)
        if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 900 then
            CastSpell(_W, CastPosition.x, CastPosition.z)
        end
    end
		end
end]]--
function CastE()
    if not EREADY then return end
        for i = 1, enemyCount do
        local enemy = enemyChamps[i]
            if GetDistance(enemy, myHero) < skillE.range then
                CastSpell(_E, enemy)
            end
        end
end
--[[
function CastR()
	for i, target in pairs(GetEnemyHeroes()) do
		if ValidTarget(target, 750) then
			CastSpell(_R, target)
		end
	end
end
]]--
function CastR()
    local damageR = function() return (50 + (GetSpellData(0).level*100) + (myHero.ap*0.50)) end
    if RREADY then
       for i = 1, enemyCount do
        local enemy1 = enemyChamps[i]
            if GetDistance(enemy1, myHero) < 750 then

                newDamage = myHero:CalcMagicDamage(enemy1, damageR()) -5
                if newDamage > enemy1.health and not WREADY then
                    CastSpell(_R, enemy1)
                end-- should probly have a config check here so users dont think ur script is broken
                for i = 1, enemyCount do
        local enemy2 = enemyChamps[i]
                    newDamage2 = myHero:CalcMagicDamage(enemy2, damageR()*2)
                    if newDamage2*.2 > enemy2.health then
                        --print("hi2")
                        if GetDistance(enemy1, enemy2) < 450 then
                            CastSpell(_R, enemy1)
                        end
                    end
                end
            end
        end
    end
end

function MinionR()
if not RREADY then return end
    if Config.keybindings.combo1.ultminion then
        local damageR = function() return (50 + (GetSpellData(0).level*100) + (myHero.ap*0.50)) end
        for index, minion in pairs(enemyMinions.objects) do
            for i = 1, enemyCount do
			local enemy = enemyChamps[i]
                if GetDistance(enemy) < 750 then
								
								
								newDamagedoublebounce = myHero:CalcMagicDamage(enemy, damageR()*3) -5
                    if newDamagedoublebounce > enemy.health then
                        DrawCircle3D(minion.x, minion.y, minion.z, 100, 1, RGB(255, 255, 255))
                        if GetDistance(minion, enemy) < 275 then
                            CastSpell(_R, enemy)
                        end
										end
                    newDamage = myHero:CalcMagicDamage(enemy, damageR()*2) -5
                    if newDamage > enemy.health then
                        DrawCircle3D(minion.x, minion.y, minion.z, 100, 1, RGB(255, 255, 255))
                        if GetDistance(minion, enemy) < 400 then
                            CastSpell(_R, enemy)
                        end

                    end
                end
            end
        end
    end

end
function findClosestEnemy()
    local closestEnemy = nil
    local currentEnemy = nil
    for i=1, heroManager.iCount do
        currentEnemy = heroManager:GetHero(i)
        if currentEnemy.team ~= myHero.team and not currentEnemy.dead and currentEnemy.visible then
            if closestEnemy == nil then
                closestEnemy = currentEnemy
            elseif GetDistance(currentEnemy) < GetDistance(closestEnemy) then
                closestEnemy = currentEnemy
            end
        end
    end
    return closestEnemy
end


function drawDamage()
             for i = 1, enemyCount do
			local enemy = enemyChamps[i]
        if enemy.visible == true and enemy.dead == false then
            local framePos = GetAbilityFramePos(enemy)
            if OnScreen(framePos, framePos) then
							if Config.Draw.drawQ2 then
                if QREADY then
                    local damageQ = function() return (40 + (GetSpellData(0).level*40) + (myHero.ap*0.65)) end
                    newDamage = myHero:CalcMagicDamage(enemy, damageQ()) - 5
                    DrawOverheadHUD(enemy, framePos, 0, newDamage, "Q", TARGB({255,255,40,255}))
                end
							end
							if not UnitHaveBuff(enemy, "brandablaze") and Config.Draw.drawW2 then
                if WREADY then
                    local damageW = function() return (30 + (GetSpellData(1).level*45) + (myHero.ap*0.6)) end
										
                    newDamage = myHero:CalcMagicDamage(enemy, damageW()) - 5
                    DrawOverheadHUD(enemy, framePos, 16, newDamage, "W", TARGB({255,0,255,255}))
							end
						end
							if UnitHaveBuff(enemy, "brandablaze") and WREADY and Config.Draw.drawW2 then 
							 local damageW = function() return (30 + (GetSpellData(1).level*45) + (myHero.ap*0.6))*1.25
							 end
										
                    newDamage = myHero:CalcMagicDamage(enemy, damageW()) - 5
                    DrawOverheadHUD(enemy, framePos, 16, newDamage, "W", TARGB({255,0,255,255}))
            
							end
							if Config.Draw.drawE2 then
                if EREADY then
                    local damageE = function() return (35 + (GetSpellData(2).level*35) + (myHero.ap*0.55)) end
                    newDamage = myHero:CalcMagicDamage(enemy, damageE()) - 5
                    DrawOverheadHUD(enemy, framePos, 30, newDamage, "E", TARGB({255,255,255,255}))
                end
							end
							if Config.Draw.drawR2 then
                if RREADY then
                    local damageR = function() return (50 + (GetSpellData(3).level*100) + (myHero.ap*0.50)) end
                    newDamage = myHero:CalcMagicDamage(enemy, damageR()) -5
                    DrawOverheadHUD(enemy, framePos, 44, newDamage, "R", TARGB({255,255,0,0}))
                end
							end
		
							if Config.Draw.drawP then
                local damagePassive = function() return (enemy.health/enemy.maxHealth*0.08) end
                newDamage = myHero:CalcMagicDamage(enemy, damagePassive()) -5
                DrawOverheadHUD(enemy, framePos, 58, newDamage, "P", TARGB({255,255,0,0}))
							end
							if Config.Draw.drawI then
                local iDmg = 0
                if iSlot ~= nil and myHero:CanUseSpell(iSlot) == READY then
                    iDmg = 50 + 20 * myHero.level
                    DrawOverheadHUD(enemy, framePos, 52, iDmg, "Ignite", TARGB({255,255,0,0}))
                end
							end
							if Config.Draw.drawCombo then
							
                if QREADY and WREADY and EREADY and RREADY then
                    local damageQ = function() return (40 + (GetSpellData(0).level*40) + (myHero.ap*0.65)) end

                    local damageW = function() return (30 + (GetSpellData(1).level*45) + (myHero.ap*0.6))*1.25 end

                    local damageE = function() return (35 + (GetSpellData(2).level*35) + (myHero.ap*0.55)) end
                    local damageR = function() return (50 + (GetSpellData(3).level*100) + (myHero.ap*0.50)) end
                    local damagePassive = function() return (enemy.health/enemy.maxHealth*0.08) end
                    newDamage = myHero:CalcMagicDamage(enemy, damageQ()+damageW()+damageE()+damageR()+damagePassive()) - 5
                    DrawOverheadHUD(enemy, framePos, 58, newDamage, "Combo", TARGB({255,255,100,100}))
                end
end


            end
        end
    end
end

--[[
	if Config.keybindings.safeattack then
		SafeStun()
	end
	if Config.keybindings.combo then
		SmartCombo()
	end
	if Config.keybindings.ult then
		CastR()
	end
	if Config.keybindings.WaveClear then
		WaveClear()
	end
	if Config.keybindings.harass.harasstoggle then
		Harass()
	end
	
-- Made by Xivia / Justh1n10 
local changelogLines = { 
    "Combo Mode: Uses a different combo on enemys depending on their",
    " distance away from you.",
		"",
    "Safe Range checks a distance set by you to autostun enemys.",
		"",
		
    "Thanks for Using Silent Brand!",
}
]]--


function DrawChangeLog()
    if Config.Changelog ~= nil then
        if Config.Changelog.Changelog then
            showChangelog = true
        else
            showChangelog = false
        end
    end

    if showChangelog then
        lineYpos = (WINDOW_H / 5) + 14
        HeightOfObject = 30 + (#changelogLines * 14)

        DrawRectangle((WINDOW_W / 2) - 203, (WINDOW_H / 5) - 3, 407, HeightOfObject + 8, 0xFF172021) -- outer line

        DrawRectangle((WINDOW_W / 2) - 200, (WINDOW_H / 5), 400, HeightOfObject + 2, 0xFF998e64) -- outline
        DrawRectangle((WINDOW_W / 2) + (1 - 200),(WINDOW_H / 5) + 1, 398, HeightOfObject, 0xFF0e1314) -- inner color

        -- top title part
        DrawRectangle((WINDOW_W / 2) + (1 - 200),(WINDOW_H / 5) + 1, 398, 24, 0xFF998e64) -- inner grey
        DrawRectangle((WINDOW_W / 2) + (1 - 200),(WINDOW_H / 5) + 1, 398, 23, 0xFF0f1b1b) -- inner white

        -- exit button
        DrawRectangle((WINDOW_W / 2) + 149,(WINDOW_H / 5) + 1, 1, 23, 0xFF998e64) -- outline background
        DrawRectangle((WINDOW_W / 2) + 150,(WINDOW_H / 5) + 1, 49, 23, 0xFF264c48) -- background
        DrawText("X", 15,(WINDOW_W / 2) + 170, (WINDOW_H / 5) + 7, 0xFFa38d63) -- X cross

        -- title
        textToDisplay = ("Silent Brand V2.1")
        textLenght = (GetTextArea(textToDisplay, 20).x / 2)

        DrawText(textToDisplay, 18,(WINDOW_W / 2) - textLenght + (string.len(textToDisplay) / 2), (WINDOW_H / 5) + 4, 0xFFfef698)

        for i, changelogLine in pairs(changelogLines) do
            lineYpos = lineYpos + 14
            DrawText(changelogLine, 15,(WINDOW_W / 2) - 194, lineYpos, 0xFFfef698)
        end
    end
    --------------------------------------------------------------------------------

end

function SpellStopper()
    InterruptGame = {}
    InterruptComplete = {
        { name = "Caitlyn"     , spell = "CaitlynAceintheHole"},
        { name = "FiddleSticks", spell = "Crowstorm"},
        { name = "FiddleSticks", spell = "DrainChannel"},
        { name = "Galio"       , spell = "GalioIdolOfDurand"},
        { name = "Karthus"     , spell = "FallenOne"},
        { name = "Katarina"    , spell = "KatarinaR"},
        { name = "Lucian"      , spell = "LucianR"},
        { name = "Malzahar"    , spell = "AlZaharNetherGrasp"},
        { name = "MissFortune" , spell = "MissFortuneBulletTime"},
        { name = "Nunu"        , spell = "AbsoluteZero"},
        { name = "Shen"        , spell = "ShenStandUnited"},
        --{ name = "Shyvana"     , spell = "blah"},--
        { name = "Urgot"       , spell = "UrgotSwap2"},
        { name = "Varus"       , spell = "VarusQ"},
        { name = "Velkoz"      , spell = "VelkozR"},
        { name = "Warwick"     , spell = "InfiniteDuress"}
        --janna ult
        --master yi mediate
        --pantehon grand skyful
        --ezreal ult
        --lux ultimate
    }

    for i, enemy in pairs(GetEnemyHeroes()) do
        for j, champion in pairs(InterruptComplete) do
            if enemy.charName == champion.name then
                table.insert(InterruptGame, champion)
            end
        end
    end
end


function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
    quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
    quality = 2 * math.pi / quality
    radius = radius*.92

    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end

    DrawLines2(points, width or 1, color or 4294967295)
end
function round(num)
    if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end
function DrawCircle2(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))

    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, Config.Draw.Width, color, Config.Draw.CL)
    end
end

function ManaTable()
        if myHero:GetSpellData(_Q).level == 1 then
            QMANA = 50
        end
        if myHero:GetSpellData(_Q).level == 2 then
            QMANA = 50
        end
        if myHero:GetSpellData(_Q).level == 3 then
            QMANA = 50
        end
        if myHero:GetSpellData(_Q).level == 4 then
            QMANA = 50
        end
        if myHero:GetSpellData(_Q).level == 5 then
            QMANA = 50
        end
        ---Q end
        if myHero:GetSpellData(_W).level == 1 then
            WMANA = 70
        end
        if myHero:GetSpellData(_W).level == 2 then
            WMANA = 75
        end
        if myHero:GetSpellData(_W).level == 3 then
            WMANA = 80
        end
        if myHero:GetSpellData(_W).level == 4 then
            WMANA = 85
        end
        if myHero:GetSpellData(_W).level == 5 then
            WMANA = 90
        end

    ---W END
    if myHero:GetSpellData(_E).level == 1 then
        EMANA = 70
    end
    if myHero:GetSpellData(_E).level == 2 then
        EMANA = 75
    end
    if myHero:GetSpellData(_E).level == 3 then
        WMANA = 80
    end
    if myHero:GetSpellData(_E).level == 4 then
        WMANA = 85
    end
    if myHero:GetSpellData(_E).level == 5 then
        WMANA = 90
    end
    ---E END

    if myHero:GetSpellData(_R).level == 1 then
        RMANA = 100
    end
    if myHero:GetSpellData(_R).level == 2 then
        WMANA = 100
    end
    if myHero:GetSpellData(_R).level == 3 then
        WMANA = 100
    end
end
---------------------

class "SxWebResult"
function SxWebResult:__init(Host, Path, Callback)
    self.Host = Host
    self.Path = Path
    self.Callback = Callback
    self.LuaSocket = require("socket")

    self.Socket = self.LuaSocket.connect(Host, 80)
    self.Socket:send("GET "..self.Path.."&rand="..math.random(99999999).." HTTP/1.0\r\nHost: "..Host.."\r\n\r\n")
    self.Socket:settimeout(0, 'b')
    self.Socket:settimeout(99999999, 't')
    self.LastPrint = ""
    self.File = ""
    AddTickCallback(function() self:GetResult() end)
end

function SxWebResult:GetResult()
    if self.Status == 'closed' then return end
    self.Receive, self.Status, self.Snipped = self.Socket:receive(1024)

    if self.Receive then
        if self.LastPrint ~= self.Receive then
            self.LastPrint = self.Receive
            self.File = self.File .. self.Receive
        end
    end

    if self.Snipped ~= "" and self.Snipped then
        self.File = self.File .. self.Snipped
    end
    if self.Status == 'closed' then
        local HeaderEnd, ContentStart = self.File:find('\r\n\r\n')
        if HeaderEnd and ContentStart then
            self.Callback(self.File:sub(ContentStart + 1))
        else
            PrintChat('Error: Could not get end of Header')
        end
    end
end
