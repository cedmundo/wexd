
-- This is a generator of IFT noise based on a map size and an amplitude function
-- tried to port this: https://www.redblobgames.com/articles/noise/introduction.html
function random_ift(amount, amplitude)
  local iter = 0
  local phase = math.random(0, 2 * math.pi)
  local freqs = {2, 4, 6, 16, 32, 64}

  local function noise(freq, nx)
    return math.sin(2*math.pi * freq*nx/amount + phase)
  end

  local function weighted_sum(wx)
    local sum = 0
    for _, freq in pairs(freqs) do
      sum = sum + (amplitude(freq) * noise(freq, wx))
    end
    return sum
  end

  local function seq(state, value)
    iter = iter + 1
    if iter > amount then
      return nil
    end

    --return math.abs(noise(1, iter) * 10)
    return math.abs(weighted_sum(iter))
  end

  return seq, nil, 0
end

function ampl_red(f)
  return 1/f
end

function ampl_pink(f)
  return 1/math.sqrt(f)
end

function ampl_white(f)
  return 1
end

function ampl_blue(f)
  return math.sqrt(f)
end

function ampl_violet(f)
  return f
end
