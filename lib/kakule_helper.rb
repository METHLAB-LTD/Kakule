module KakuleHelper
  def self.geo_distance(lat1, lon1, lat2, lon2)
    a = 6378137
    b = 6356752.314245
    f = 1/298.257223563
    vL = toRad((lon2-lon1))
    vU1 = Math.atan((1-f) * Math.tan(toRad(lat1)))
    vU2 = Math.atan((1-f) * Math.tan(toRad(lat2)))
    sinU1 = Math.sin(vU1)
    cosU1 = Math.cos(vU1)
    sinU2 = Math.sin(vU2)
    cosU2 = Math.cos(vU2)
    lambda = vL
    lambdaP = lambda
    iterLimit = 100
    begin
      sinLambda = Math.sin(lambda)
      cosLambda = Math.cos(lambda)
      sinSigma = Math.sqrt((cosU2*sinLambda) * (cosU2*sinLambda) + (cosU1*sinU2-sinU1*cosU2*cosLambda) * (cosU1*sinU2-sinU1*cosU2*cosLambda))
      return 0 if (sinSigma==0)
      cosSigma = sinU1*sinU2 + cosU1*cosU2*cosLambda
      sigma = Math.atan2(sinSigma, cosSigma)
      sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma
      cosSqAlpha = 1 - sinAlpha*sinAlpha
      cos2SigmaM = cosSigma - 2*sinU1*sinU2/cosSqAlpha
      #cos2SigmaM = 0 if (isNaN(cos2SigmaM))
      vC = f/16*cosSqAlpha*(4+f*(4-3*cosSqAlpha))
      lambdaP = lambda
      lambda = vL + (1-vC) * f * sinAlpha * (sigma + vC*sinSigma*(cos2SigmaM+vC*cosSigma*(-1+2*cos2SigmaM*cos2SigmaM)))
    end while ((lambda-lambdaP).abs > 1e-12 && --iterLimit>0)

    return false if (iterLimit==0) 

    uSq = cosSqAlpha * (a*a - b*b) / (b*b)
    vA = 1 + uSq/16384*(4096+uSq*(-768+uSq*(320-175*uSq)))
    vB = uSq/1024 * (256+uSq*(-128+uSq*(74-47*uSq)))
    deltaSigma = vB*sinSigma*(cos2SigmaM+vB/4*(cosSigma*(-1+2*cos2SigmaM*cos2SigmaM)-vB/6*cos2SigmaM*(-3+4*sinSigma*sinSigma)*(-3+4*cos2SigmaM*cos2SigmaM)))
    s = b*vA*(sigma-deltaSigma)
    return s; #in meters
  end

  def self.toRad(deg)
    deg * Math::PI/180
  end
end