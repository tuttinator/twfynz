module Seeds
  module Elections

    # Election types:
    #  General Election - common, every 3 years in modern times
    #  By-elections - when a vacancy occurs during the parliamentary term
    #  Supplemental Elections - rare, and in the early Parliaments
    #  Maori Election - coincide with the same Parliamentary term, but voting
    #                   occurred on different days
    #
    # Up until the 1960s there was an additional unelected house of Parliament
    # the Legislative Council, which was abolished by a suicide squad (metaphorical)

    module GeneralElections

      DATA = 
        [
          { voting_commenced_on: Date.new(1853,  7, 14), voting_finished_on: Date.new(1853, 10,  1), parliament: 1 },
          { voting_commenced_on: Date.new(1855, 10, 26), voting_finished_on: Date.new(1855, 12, 28), parliament: 2 },
          { voting_commenced_on: Date.new(1860, 12, 12), voting_finished_on: Date.new(1861,  3, 28), parliament: 3 },
          { voting_commenced_on: Date.new(1866,  2, 12), voting_finished_on: Date.new(1866,  4,  6), parliament: 4 },
          { voting_commenced_on: Date.new(1871,  1, 14), voting_finished_on: Date.new(1871,  2, 23), parliament: 5 },
          { voting_commenced_on: Date.new(1875, 12, 20), voting_finished_on: Date.new(1876,  1, 29), parliament: 6 },
          { voting_commenced_on: Date.new(1879,  8, 28), voting_finished_on: Date.new(1879,  9, 15), parliament: 7 },
          { voting_commenced_on: Date.new(1881, 12,  9), voting_finished_on: Date.new(1881, 12,  9), parliament: 8 },
          { voting_commenced_on: Date.new(1884,  7, 22), voting_finished_on: Date.new(1884,  7, 22), parliament: 9 },
          { voting_commenced_on: Date.new(1887,  9, 26), voting_finished_on: Date.new(1887,  9, 26), parliament: 10 },
          { voting_commenced_on: Date.new(1890, 12,  5), voting_finished_on: Date.new(1890, 12,  5), parliament: 11 },
          { voting_commenced_on: Date.new(1893, 12, 20), voting_finished_on: Date.new(1893, 12, 20), parliament: 12 },
          { voting_commenced_on: Date.new(1896, 12, 19), voting_finished_on: Date.new(1896, 12, 19), parliament: 13 },
          { voting_commenced_on: Date.new(1899, 12,  6), voting_finished_on: Date.new(1899, 12,  6), parliament: 14 },
          { voting_commenced_on: Date.new(1902, 11, 25), voting_finished_on: Date.new(1902, 11, 25), parliament: 15 },
          { voting_commenced_on: Date.new(1905, 12,  6), voting_finished_on: Date.new(1905, 12,  6), parliament: 16 },
          { voting_commenced_on: Date.new(1908, 11, 17), voting_finished_on: Date.new(1908, 12,  1), parliament: 17 },
          { voting_commenced_on: Date.new(1911, 12,  7), voting_finished_on: Date.new(1911, 12, 14), parliament: 18 },
          { voting_commenced_on: Date.new(1914, 12, 10), voting_finished_on: Date.new(1914, 12, 10), parliament: 19 },
          { voting_commenced_on: Date.new(1919, 12, 17), voting_finished_on: Date.new(1919, 12, 17), parliament: 20 },
          { voting_commenced_on: Date.new(1922, 12,  7), voting_finished_on: Date.new(1922, 12,  7), parliament: 21 },
          { voting_commenced_on: Date.new(1925, 11,  4), voting_finished_on: Date.new(1925, 11,  4), parliament: 22 },
          { voting_commenced_on: Date.new(1928, 11, 14), voting_finished_on: Date.new(1928, 11, 14), parliament: 23 },
          { voting_commenced_on: Date.new(1931, 12,  2), voting_finished_on: Date.new(1931, 12,  2), parliament: 24 },
          { voting_commenced_on: Date.new(1935, 11, 27), voting_finished_on: Date.new(1935, 11, 27), parliament: 25 },
          { voting_commenced_on: Date.new(1938, 10, 15), voting_finished_on: Date.new(1938, 10, 15), parliament: 26 },
          { voting_commenced_on: Date.new(1943,  9, 25), voting_finished_on: Date.new(1943,  9, 25), parliament: 27 },
          { voting_commenced_on: Date.new(1946, 11, 27), voting_finished_on: Date.new(1946, 11, 27), parliament: 28 },
          { voting_commenced_on: Date.new(1949, 11, 30), voting_finished_on: Date.new(1949, 11, 30), parliament: 29 },
          { voting_commenced_on: Date.new(1951,  9,  1), voting_finished_on: Date.new(1951,  9,  1), parliament: 30 },
          { voting_commenced_on: Date.new(1954, 11, 13), voting_finished_on: Date.new(1954, 11, 13), parliament: 31 },
          { voting_commenced_on: Date.new(1957, 11, 30), voting_finished_on: Date.new(1957, 11, 30), parliament: 32 },
          { voting_commenced_on: Date.new(1960, 11, 26), voting_finished_on: Date.new(1960, 11, 26), parliament: 33 },
          { voting_commenced_on: Date.new(1963, 11, 30), voting_finished_on: Date.new(1963, 11, 30), parliament: 34 },
          { voting_commenced_on: Date.new(1966, 11, 26), voting_finished_on: Date.new(1966, 11, 26), parliament: 35 },
          { voting_commenced_on: Date.new(1969, 11, 29), voting_finished_on: Date.new(1969, 11, 29), parliament: 36 },
          { voting_commenced_on: Date.new(1972, 11, 25), voting_finished_on: Date.new(1972, 11, 25), parliament: 37 },
          { voting_commenced_on: Date.new(1975, 11, 29), voting_finished_on: Date.new(1975, 11, 29), parliament: 38 },
          { voting_commenced_on: Date.new(1978, 11, 25), voting_finished_on: Date.new(1978, 11, 25), parliament: 39 },
          { voting_commenced_on: Date.new(1981, 11, 28), voting_finished_on: Date.new(1981, 11, 28), parliament: 40 },
          { voting_commenced_on: Date.new(1984,  7, 14), voting_finished_on: Date.new(1984,  7, 14), parliament: 41 },
          { voting_commenced_on: Date.new(1987,  8, 15), voting_finished_on: Date.new(1987,  8, 15), parliament: 42 },
          { voting_commenced_on: Date.new(1990, 10, 27), voting_finished_on: Date.new(1990, 10, 27), parliament: 43 },
          { voting_commenced_on: Date.new(1993, 11,  6), voting_finished_on: Date.new(1993, 11,  6), parliament: 44 },
          { voting_commenced_on: Date.new(1996, 10, 12), voting_finished_on: Date.new(1996, 10, 12), parliament: 45 },
          { voting_commenced_on: Date.new(1999, 11, 27), voting_finished_on: Date.new(1999, 11, 27), parliament: 46 },
          { voting_commenced_on: Date.new(2002,  7, 27), voting_finished_on: Date.new(2002,  7, 27), parliament: 47 },
          { voting_commenced_on: Date.new(2005,  9, 17), voting_finished_on: Date.new(2005,  9, 17), parliament: 48 },
          { voting_commenced_on: Date.new(2008, 11,  8), voting_finished_on: Date.new(2008, 11,  8), parliament: 49 },
          { voting_commenced_on: Date.new(2011, 11, 26), voting_finished_on: Date.new(2011, 11, 26), parliament: 50 }
      ]
    end

    module MaoriElections

      DATA = 
      [
        { voting_commenced_on: Date.new(1868,  4, 15), voting_finished_on: Date.new(1868,  5,  6), parliament: 4, note: 'First Maori Election' },
        { voting_commenced_on: Date.new(1871,  2,  1), voting_finished_on: Date.new(1871,  2, 15), parliament: 5 },
        { voting_commenced_on: Date.new(1876,  1,  4), voting_finished_on: Date.new(1876,  1, 15), parliament: 6 },
        { voting_commenced_on: Date.new(1879,  9,  8), voting_finished_on: Date.new(1879,  9,  8), parliament: 7 },
        { voting_commenced_on: Date.new(1881, 12,  8), voting_finished_on: Date.new(1881, 12,  8), parliament: 8 },
        { voting_commenced_on: Date.new(1884,  7, 21), voting_finished_on: Date.new(1884,  7, 21), parliament: 9 },
        { voting_commenced_on: Date.new(1887,  9,  7), voting_finished_on: Date.new(1887,  9,  7), parliament: 10 },
        { voting_commenced_on: Date.new(1890, 11, 27), voting_finished_on: Date.new(1890, 11, 27), parliament: 11 },
        { voting_commenced_on: Date.new(1893, 11, 28), voting_finished_on: Date.new(1893, 11, 28), parliament: 12 },
        { voting_commenced_on: Date.new(1896, 12,  4), voting_finished_on: Date.new(1896, 12,  4), parliament: 13 },
        { voting_commenced_on: Date.new(1899, 12, 19), voting_finished_on: Date.new(1899, 12, 19), parliament: 14 },
        { voting_commenced_on: Date.new(1902, 12, 22), voting_finished_on: Date.new(1902, 12, 22), parliament: 15 },
        { voting_commenced_on: Date.new(1905, 12, 20), voting_finished_on: Date.new(1905, 12, 20), parliament: 16 },
        { voting_commenced_on: Date.new(1908, 12,  2), voting_finished_on: Date.new(1908, 12,  2), parliament: 17 },
        { voting_commenced_on: Date.new(1911, 12, 19), voting_finished_on: Date.new(1911, 12, 19), parliament: 18 },
        { voting_commenced_on: Date.new(1914, 12, 11), voting_finished_on: Date.new(1914, 12, 11), parliament: 19 },
        { voting_commenced_on: Date.new(1919, 12, 16), voting_finished_on: Date.new(1919, 12, 16), parliament: 20 },
        { voting_commenced_on: Date.new(1922, 12,  6), voting_finished_on: Date.new(1922, 12,  6), parliament: 21 },
        { voting_commenced_on: Date.new(1925, 11,  3), voting_finished_on: Date.new(1925, 11,  3), parliament: 22 },
        { voting_commenced_on: Date.new(1928, 11, 13), voting_finished_on: Date.new(1928, 11, 13), parliament: 23 },
        { voting_commenced_on: Date.new(1931, 12,  1), voting_finished_on: Date.new(1931, 12,  1), parliament: 24 },
        { voting_commenced_on: Date.new(1935, 11, 26), voting_finished_on: Date.new(1935, 11, 26), parliament: 25 },
        { voting_commenced_on: Date.new(1938, 10, 14), voting_finished_on: Date.new(1938, 10, 14), parliament: 26 },
        { voting_commenced_on: Date.new(1943,  9, 24), voting_finished_on: Date.new(1943,  9, 24), parliament: 27 },
        { voting_commenced_on: Date.new(1946, 11, 26), voting_finished_on: Date.new(1946, 11, 26), parliament: 28 },
        { voting_commenced_on: Date.new(1949, 11, 29), voting_finished_on: Date.new(1949, 11, 29), parliament: 29 }
      ]

      # 1951 onwards Maori elections were held on the same day as the General election

    end
  end
end