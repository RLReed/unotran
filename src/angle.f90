module angle
  ! ############################################################################
  ! Setup the angular quadrature
  ! ############################################################################

  use control, only : dp

  implicit none

  real(kind=dp), allocatable, dimension(:) :: &
      mu,                       & ! cosine of angles
      eta,                      & ! sine of angles
      wt                          ! quadrature weight (sum to 1)
  real(kind=dp), allocatable, dimension(:,:) :: &
      p_leg                       ! Container for the legendre polynomials
  integer, parameter :: &
      GL = 1, &                   ! Gauss Legendre quadrature
      DGL = 2                     ! Double Gauss Legendre quadrature
  real(kind=dp), parameter :: &
      PI = 3.141592653589793116_8 ! Setting the value of pi

  contains

  subroutine initialize_angle()
    ! ##########################################################################
    ! Allocate quadrature arrays
    ! ##########################################################################

    ! Use Statements
    use control, only : spatial_dimension, angle_option, number_angles, number_angles_per_octant, angle_order

    ! Variable definitions
    integer :: &
        a, & ! Angle index
        i, & ! Counting variable
        j    ! Counting variable
    real(kind=dp), allocatable, dimension(:) :: &
        mu_vals, & !
        wt_vals    !
    integer, allocatable, dimension(:) :: &
        wt_map

    if (spatial_dimension == 1) then

      number_angles_per_octant = angle_order
      number_angles = 2 * number_angles_per_octant
      allocate(mu(number_angles_per_octant), wt(number_angles_per_octant))

      ! Generate the Legendre quadrature
      if (angle_option == GL) then
        call generate_gl_parameters(number_angles, mu, wt)
      else if (angle_option == DGL) then
        call generate_gl_parameters(number_angles_per_octant, mu, wt)
        mu = 0.5_8 * mu + 0.5_8
        wt = 0.5_8 * wt
        do a = 1, number_angles_per_octant / 2
          mu(number_angles_per_octant - a + 1) = 1.0_8 - mu(a)
          wt(number_angles_per_octant - a + 1) = wt(a)
        end do  ! End a loop
      else
        stop "Invalid quadrature option."
      end if
    else if (spatial_dimension == 2) then

      if (angle_order < 2 .or. angle_order > 24) then
        print *, 'angles are only defined for 2 <= angle_order <= 24'
        stop
      else if (modulo(angle_order,  2) /= 0) then
        print *, 'angles are only defined for even angle_order'
      end if

      ! Compute the total number of angles
      number_angles_per_octant = angle_order * (angle_order + 2) / 8
      number_angles = number_angles_per_octant * 2 ** spatial_dimension
      allocate(mu(number_angles_per_octant), eta(number_angles_per_octant), &
               wt(number_angles_per_octant), wt_map(number_angles_per_octant))
      if (angle_order == 2) then
        allocate(mu_vals(1), wt_vals(1))
        mu_vals(1) = 0.577350269189625764509149_8
        wt_vals(1) = 1.000000000000000000000000_8
        wt_map = [0]
      else if (angle_order == 4) then
        allocate(mu_vals(2), wt_vals(1))
        mu_vals(1) = 0.350021174581540677777041_8
        mu_vals(2) = 0.868890300722201205229788_8
        wt_vals(1) = 0.333333333333333333333333_8
        wt_map = [0, 0, 0]
      else if (angle_order == 6) then
        allocate(mu_vals(3), wt_vals(2))
        mu_vals(1) = 0.266635401516704720331535_8
        mu_vals(2) = 0.681507726536546927403750_8
        mu_vals(3) = 0.926180935517489107558380_8
        wt_vals(1) = 0.176126130863383433783565_8
        wt_vals(2) = 0.157207202469949899549768_8
        wt_map = [0, 1, 0, 1, 1, 0]
      else if (angle_order == 8) then
        allocate(mu_vals(4), wt_vals(3))
        mu_vals(1) = 0.218217890235992381266097_8
        mu_vals(2) = 0.577350269189625764509149_8
        mu_vals(3) = 0.786795792469443145800830_8
        mu_vals(4) = 0.951189731211341853132399_8
        wt_vals(1) = 0.120987654320987654320988_8
        wt_vals(2) = 0.0907407407407407407407407_8
        wt_vals(3) = 0.0925925925925925925925926_8
        wt_map = [0, 1, 1, 0, 1, 2, 1, 1, 1, 0]
      else if (angle_order == 10) then
        allocate(mu_vals(5), wt_vals(4))
        mu_vals(1) = 0.189321326478010476671494_8
        mu_vals(2) = 0.508881755582618974382711_8
        mu_vals(3) = 0.694318887594384317279217_8
        mu_vals(4) = 0.839759962236684758403029_8
        mu_vals(5) = 0.963490981110468484701598_8
        wt_vals(1) = 0.0893031479843567214704325_8
        wt_vals(2) = 0.0725291517123655242296233_8
        wt_vals(3) = 0.0450437674364086390490892_8
        wt_vals(4) = 0.0539281144878369243545650_8
        wt_map = [0, 1, 2, 1, 0, 1, 3, 3, 1, 2, 3, 2, 1, 1, 0]
      else if (angle_order == 12) then
        allocate(mu_vals(6), wt_vals(5))
        mu_vals(1) = 0.167212652822713264084504_8
        mu_vals(2) = 0.459547634642594690016761_8
        mu_vals(3) = 0.628019096642130901034766_8
        mu_vals(4) = 0.760021014833664062877138_8
        mu_vals(5) = 0.872270543025721502340662_8
        mu_vals(6) = 0.971637719251358378302376_8
        wt_vals(1) = 0.0707625899700910439766549_8
        wt_vals(2) = 0.0558811015648888075828962_8
        wt_vals(3) = 0.0373376737588285824652402_8
        wt_vals(4) = 0.0502819010600571181385765_8
        wt_vals(5) = 0.0258512916557503911218290_8
        wt_map = [0, 1, 2, 2, 1, 0, 1, 3, 4, 3, 1, 2, 4, 4, 2, 2, 3, 2, 1, 1, 0]
      else if (angle_order == 14) then
        allocate(mu_vals(7), wt_vals(7))
        mu_vals(1) = 0.151985861461031912404799_8
        mu_vals(2) = 0.422156982304796966896263_8
        mu_vals(3) = 0.577350269189625764509149_8
        mu_vals(4) = 0.698892086775901338963210_8
        mu_vals(5) = 0.802226255231412057244328_8
        mu_vals(6) = 0.893691098874356784901111_8
        mu_vals(7) = 0.976627152925770351762946_8
        wt_vals(1) = 0.0579970408969969964063611_8
        wt_vals(2) = 0.0489007976368104874582568_8
        wt_vals(3) = 0.0227935342411872473257345_8
        wt_vals(4) = 0.0394132005950078294492985_8
        wt_vals(5) = 0.0380990861440121712365891_8
        wt_vals(6) = 0.0258394076418900119611012_8
        wt_vals(7) = 0.00826957997262252825269908_8
        wt_map = [0, 1, 2, 3, 2, 1, 0, 1, 4, 5, 5, 4, 1, 2, &
                  5, 6, 5, 2, 3, 5, 5, 3, 2, 4, 2, 1, 1, 0]
      else if (angle_order == 16) then
        allocate(mu_vals(8), wt_vals(8))
        mu_vals(1) = 0.138956875067780344591732_8
        mu_vals(2) = 0.392289261444811712294197_8
        mu_vals(3) = 0.537096561300879079878296_8
        mu_vals(4) = 0.650426450628771770509703_8
        mu_vals(5) = 0.746750573614681064580018_8
        mu_vals(6) = 0.831996556910044145168291_8
        mu_vals(7) = 0.909285500943725291652116_8
        mu_vals(8) = 0.980500879011739882135849_8
        wt_vals(1) = 0.0489872391580385335008367_8
        wt_vals(2) = 0.0413295978698440232405505_8
        wt_vals(3) = 0.0203032007393652080748070_8
        wt_vals(4) = 0.0265500757813498446015484_8
        wt_vals(5) = 0.0379074407956004002099321_8
        wt_vals(6) = 0.0135295047786756344371600_8
        wt_vals(7) = 0.0326369372026850701318409_8
        wt_vals(8) = 0.0103769578385399087825920_8
        wt_map = [0, 1, 2, 3, 3, 2, 1, 0, 1, 4, 5, 6, 5, 4, &
                  1, 2, 5, 7, 7, 5, 2, 3, 6, 7, 6, 3, 3, 5, &
                  5, 3, 2, 4, 2, 1, 1, 0]
      else if (angle_order == 18) then
        allocate(mu_vals(9), wt_vals(10))
        mu_vals(1)  = 0.129344504545924818514086_8
        mu_vals(2)  = 0.368043816053393605686086_8
        mu_vals(3)  = 0.504165151725164054411848_8
        mu_vals(4)  = 0.610662549934881101060239_8
        mu_vals(5)  = 0.701166884252161909657019_8
        mu_vals(6)  = 0.781256199495913171286914_8
        mu_vals(7)  = 0.853866206691488372341858_8
        mu_vals(8)  = 0.920768021061018932899055_8
        mu_vals(9)  = 0.983127661236087115272518_8
        wt_vals(1)  = 0.0422646448843821748535825_8
        wt_vals(2)  = 0.0376127473827281471532380_8
        wt_vals(3)  = 0.0122691351637405931037187_8
        wt_vals(4)  = 0.0324188352558815048715646_8
        wt_vals(5)  = 0.00664438614619073823264082_8
        wt_vals(6)  = 0.0312093838436551370068864_8
        wt_vals(7)  = 0.0160127252691940275641645_8
        wt_vals(8)  = 0.0200484595308572875885066_8
        wt_vals(9)  = 0.000111409402059638628382279_8
        wt_vals(10) = 0.0163797038522425240494567_8
        wt_map = [0, 1, 2, 3, 4, 3, 2, 1, 0, 1, 5, 6, 7, 7, &
                  6, 5, 1, 2, 6, 8, 9, 8, 6, 2, 3, 7, 9, 9, &
                  7, 3, 4, 7, 8, 7, 4, 3, 6, 6, 3, 2, 5, 2, &
                  1, 1, 0]
      else if (angle_order == 20) then
        allocate(mu_vals(10), wt_vals(12))
        mu_vals(1)  = 0.120603343036693597409418_8
        mu_vals(2)  = 0.347574292315847257336779_8
        mu_vals(3)  = 0.476519266143665680817278_8
        mu_vals(4)  = 0.577350269189625764509149_8
        mu_vals(5)  = 0.663020403653288019308783_8
        mu_vals(6)  = 0.738822561910371432904974_8
        mu_vals(7)  = 0.807540401661143067193530_8
        mu_vals(8)  = 0.870852583760463975580977_8
        mu_vals(9)  = 0.929863938955324566667817_8
        mu_vals(10) = 0.985347485558646574628509_8
        wt_vals(1)  = 0.0370210490604481342320295_8
        wt_vals(2)  = 0.0332842165376314841003910_8
        wt_vals(3)  = 0.0111738965965092519614021_8
        wt_vals(4)  = 0.0245177476959359285418987_8
        wt_vals(5)  = 0.0135924329650041789567081_8
        wt_vals(6)  = 0.0318029065936585971501960_8
        wt_vals(7)  = 0.00685492401402507781062634_8
        wt_vals(8)  = 0.0308105481755299327227893_8
        wt_vals(9)  = -0.000139484716502602877593527_8
        wt_vals(10) = 0.00544675187330776223879437_8
        wt_vals(11) = 0.00474564692642379971238396_8
        wt_vals(12) = 0.0277298541009064049325246_8
        wt_map = [0, 1, 2, 3, 4, 4, 3, 2, 1, 0, 1, 5, 6, 7, &
                  8, 7, 6, 5, 1, 2, 6, 9, 10, 10, 9, 6, 2, 3, 7, &
                  10, 11, 10, 7, 3, 4, 8, 10, 10, 8, 4, 4, 7, 9, 7, 4, &
                  3, 6, 6, 3, 2, 5, 2, 1, 1, 0]
      else if (angle_order == 22) then
        allocate(mu_vals(11), wt_vals(14))
        mu_vals(1)  = 0.113888641383070838173488_8
        mu_vals(2)  = 0.330271760593086736334651_8
        mu_vals(3)  = 0.452977095507524183904005_8
        mu_vals(4)  = 0.548905330875560154226714_8
        mu_vals(5)  = 0.630401360620980621392149_8
        mu_vals(6)  = 0.702506006153654989703184_8
        mu_vals(7)  = 0.767869456282208576047898_8
        mu_vals(8)  = 0.828089557415325768804621_8
        mu_vals(9)  = 0.884217805921983001958912_8
        mu_vals(10) = 0.936989829997455780115072_8
        mu_vals(11) = 0.986944149751056870330152_8
        wt_vals(1)  = 0.0329277718552552308051381_8
        wt_vals(2)  = 0.0309569328165031538543025_8
        wt_vals(3)  = 0.00577105953220643022391829_8
        wt_vals(4)  = 0.0316834548379952775919418_8
        wt_vals(5)  = -0.00669350304140992494103696_8
        wt_vals(6)  = 0.0368381622687682466526634_8
        wt_vals(7)  = 0.0273139698006629537455404_8
        wt_vals(8)  = 0.0100962716435030437817055_8
        wt_vals(9)  = 0.0195181067555849392224199_8
        wt_vals(10) = 0.0117224275470949786864925_8
        wt_vals(11) = -0.00442773155233893239996431_8
        wt_vals(12) = 0.0156214785078803432781324_8
        wt_vals(13) = -0.0101774221315738297143270_8
        wt_vals(14) = 0.0135061258938431808485310_8
        wt_map = [0, 1, 2, 3, 4, 5, 4, 3, 2, 1, 0, 1, 6, 7, 8, 9, &
                  9, 8, 7, 6, 1, 2, 7, 10, 11, 12, 11, 10, 7, 2, 3, &
                  8, 11, 13, 13, 11, 8, 3, 4, 9, 12, 13, 12, 9, 4, 5, &
                  9, 11, 11, 9, 5, 4, 8, 10, 8, 4, 3, 7, 7, 3, 2, 6, 2, 1, 1, 0]
      else if (angle_order == 24) then
        allocate(mu_vals(12), wt_vals(16))
        mu_vals(1)  = 0.107544208775147285552086_8
        mu_vals(2)  = 0.315151630853896874875332_8
        mu_vals(3)  = 0.432522073446742487657060_8
        mu_vals(4)  = 0.524242441631224399254880_8
        mu_vals(5)  = 0.602150256328323868809286_8
        mu_vals(6)  = 0.671073561381361944701265_8
        mu_vals(7)  = 0.733549261041044861004094_8
        mu_vals(8)  = 0.791106384731321324814121_8
        mu_vals(9)  = 0.844750913317919895113069_8
        mu_vals(10) = 0.895186516397704814461305_8
        mu_vals(11) = 0.942928254285052510917188_8
        mu_vals(12) = 0.988366574868785749937406_8
        wt_vals(1)  = 0.0295284942030736546025272_8
        wt_vals(2)  = 0.0281530651743695026834932_8
        wt_vals(3)  = 0.00519730128072174996473824_8
        wt_vals(4)  = 0.0259897467786242920448933_8
        wt_vals(5)  = 0.00146378160153344429844948_8
        wt_vals(6)  = 0.0166609651269037212368055_8
        wt_vals(7)  = 0.0281343344093849194875108_8
        wt_vals(8)  = 0.00214364311909247909952968_8
        wt_vals(9)  = 0.0331943417648083019611294_8
        wt_vals(10) = -0.0142483904822400753741381_8
        wt_vals(11) = 0.0416812529998231580614934_8
        wt_vals(12) = 0.00323522898964475022578598_8
        wt_vals(13) = 0.000813552611571786631179287_8
        wt_vals(14) = 0.00228403610697848813660369_8
        wt_vals(15) = 0.0338971925236628645848112_8
        wt_vals(16) = -0.00644725595698339499416262_8
        wt_map = [0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0, 1, 6, 7, 8, 9, 10, &
                  9, 8, 7, 6, 1, 2, 7, 11, 12, 13, 13, 12, 11, 7, 2, 3, 8, &
                  12, 14, 15, 14, 12, 8, 3, 4, 9, 13, 15, 15, 13, 9, 4, 5, 10, &
                  13, 14, 13, 10, 5, 5, 9, 12, 12, 9, 5, 4, 8, 11, 8, 4, 3, 7, &
                  7, 3, 2, 6, 2, 1, 1, 0]
      else
        allocate(mu_vals(0), wt_vals(0))
      end if

      a = 1
      do i = 0, angle_order / 2 - 1
        do j = 0, angle_order / 2 - i - 1
          mu(a) = mu_vals(i + 1)
          eta(a) = mu_vals(j + 1)
          wt(a) = wt_vals(wt_map(a) + 1)
          a = a + 1
        end do  ! End j loop
      end do  ! End i loop

      wt(:) = 0.5_8 * PI * wt(:)

      deallocate(mu_vals, wt_vals)

    end if

  end subroutine initialize_angle

  subroutine finalize_angle()
    ! ##########################################################################
    ! Deallocated quadrature arrays
    ! ##########################################################################

    if (allocated(mu)) then
      deallocate(mu)
    end if
    if (allocated(eta)) then
      deallocate(eta)
    end if
    if (allocated(wt)) then
      deallocate(wt)
    end if
    if (allocated(p_leg)) then
      deallocate(p_leg)
    end if
  end subroutine finalize_angle

  subroutine generate_gl_parameters(m, x, w)
    ! ##########################################################################
    ! Generate Gauss-Legendre parameters.
    ! ##########################################################################

    ! Variable definitions
    integer, intent(in) :: &
        m    ! Number of angles
    real(kind=dp), intent(inout), dimension(:) :: &
        x, & ! Quadrature points
        w    ! Quadrature weights
    integer :: &
        i, & ! Looping variable
        j    ! Looping variable
    real(kind=dp) :: &
        p, & ! Legendre polynomial value
        dp   ! Double Legendre polynomial value

    ! The roots are symmetric, so we only find half of them.
    do i = 1, int(m / 2) + mod(m, 2)
      ! Asymptotic approx. due to F. Tricomi, Ann. Mat. Pura Appl., 31 (1950)
      x(i) = cos(pi * (i - 0.25_8) / (m + 0.5_8)) * (1.0_8 - 0.125_8 * (1.0_8 / m ** 2 - 1.0_8 / m ** 3.0_8))
      do j = 1, 100
        p = legendre_p(m, x(i))
        dp = d_legendre_p(m, x(i))
        if (abs(p/dp) < 1e-16_8) then
          exit
        end if
        ! Newton step
        x(i) = x(i) - p / dp
      end do  ! End j loop
      w(i) = 2.0_8 / ((1.0_8 - x(i) ** 2.0_8) * d_legendre_p(m, x(i)) ** 2.0_8)
    end do  ! End i loop

  end subroutine generate_gl_parameters

  subroutine initialize_polynomials()
    ! ##########################################################################
    ! Fill p_leg with the discrete column vectors of DLP
    ! ##########################################################################

    ! Use Statements
    use control, only : number_angles, number_legendre, spatial_dimension, number_angles_per_octant

    ! Variable definitions
    integer :: &
        l,             & ! Legendre order index
        ll,            & ! Total order
        o,             & ! Octant index
        m,             & ! Legendre moment index
        mu_sign,       & ! Sign of the cosine of angle
        eta_sign,      & ! Sign of the sine of angle
        an,            & ! Global angle index
        a                ! Angle index
    real(kind=dp) :: &
        xi               ! direction cosine w/r to z axis

    if (spatial_dimension == 1) then
      allocate(p_leg(0:number_legendre, number_angles))

      do a = 1, number_angles_per_octant
        do l = 0, number_legendre
          p_leg(l, a) = legendre_p(l, mu(a))
          p_leg(l, number_angles - a + 1) = legendre_p(l, -mu(a))
        end do  ! End l loop
      end do  ! End a loop
    else if (spatial_dimension == 2) then
      ll = 0
      do l = 0, number_legendre
        do m = -l, l
          ll = ll + 1
        end do  ! End m loop
      end do  ! End l loop

      allocate(p_leg(0:(number_legendre + 1) ** 2 - 1, number_angles))

      do o = 1, 4
        mu_sign = merge(1, -1, o ==1 .or. o == 2)
        eta_sign = merge(1, -1, o == 1 .or. o == 4)
        do a = 1, number_angles_per_octant
          an = (o - 1) * number_angles_per_octant + a
          xi = abs(sqrt(1 - mu(a) ** 2 - eta(a) ** 2))
          ll = 0
          do l = 0, number_legendre
            do m = -l, l
              p_leg(ll, an) = generate_y_lm(l, m, mu_sign * mu(a), eta_sign * eta(a), xi)
              p_leg(ll, an) = p_leg(ll, an) + generate_y_lm(l, m, mu_sign * mu(a), eta_sign * eta(a), -xi)
              p_leg(ll, an) = p_leg(ll, an) * 0.5
              ll = ll + 1
            end do  ! End m loop
          end do  ! End l loop
        end do  ! End a loop
      end do  ! End o loop
    end if

  end subroutine initialize_polynomials

  real(kind=dp) function legendre_p(l, x)
    ! ##########################################################################
    ! Compute P_l(x) using recursion relationship
    ! ##########################################################################

    integer, intent(in) :: &
        l      ! Order of legendre polynomial
    real(kind=dp), intent(in) :: &
        x      ! Coordinate for polynomial value
    real(kind=dp) :: &
        P_0, & ! Polynomial for order l
        P_1, & ! Polynomial for order l-1
        P_2    ! Polynomial for order l-2
    integer :: &
        m      ! Order index

    if (l == 0) then
      P_0 = 1.0_8
    else if (l == 1) then
      P_0 = x
    else
      P_1 = 1.0_8 ! P(l-2, x)
      P_0 = x     ! P(l-1, x)
      do m = 2, l
        P_2 = P_1
        P_1 = P_0
        P_0 = ((2 * m - 1) * x * P_1 - (m - 1) * P_2) / m
      end do  ! End m loop
    end if
    legendre_p = P_0

  end function legendre_p

  real(kind=dp) function d_legendre_p(l, x)
    ! ##########################################################################
    ! Compute dP_l/dx using recursion relationship
    ! ##########################################################################

    integer, intent(in) :: &
        l ! Order of legendre polynomial
    real(kind=dp), intent(in) :: &
        x ! Coordinate for polynomial value

    if (l == 0) then
      d_legendre_p = 0.0_8
    else
      d_legendre_p = (legendre_p(l - 1, x) - x * legendre_p(l, x)) * l / (1 - x ** 2)
    end if

  end function d_legendre_p

  real(kind=dp) function generate_y_lm(l, m, mu, eta, xi)
    ! ##########################################################################
    ! Calculate the spherical harmonic of degree l, order m
    ! ##########################################################################

    integer, intent(in) :: &
        l,   & ! Legendre order (or spherical harmonic degree)
        m      ! Spherical harmonic order
    real(kind=dp), intent(in) :: &
        mu,  & ! direction cosine w/r to x axis
        eta, & ! direction cosine w/r to y axis
        xi     ! direction cosine w/r to z axis

    if (l < 0) then
      print *, 'Bad value for l in angle.f90 (l < 0)'
      stop
    else if (abs(m) > l) then
      print *, 'Bad value for m in angle.f90 (abs(m) > 0)'
      stop
    else if (abs(mu) > 1) then
      print *, 'Bad value for mu in angle.f90 (abs(mu) > 1)'
      stop
    else if (abs(eta) > 1) then
      print *, 'Bad value for eta in angle.f90 (abs(eta) > 1)'
      stop
    else if (abs(xi) > 1) then
      print *, 'Bad value for xi in angle.f90 (abs(xi) > 1)'
      stop
    else if (mu ** 2 + eta ** 2 + xi ** 2 - 1 > 1e-5) then
      print *, 'Angles do not math to unity'
      stop
    end if

    if (l == 0) then
      if (m == 0) then
        ! R_0^0 = 1.0
        generate_y_lm = 1.0
      end if
    else if (l == 1) then
      if (m == -1) then
        ! R_1^-1 = eta
        generate_y_lm = eta
      else if (m == 0) then
        ! R_1^0 = xi
        generate_y_lm = xi
      else if (m == 1) then
        ! R_1^1 = mu
        generate_y_lm = mu
      end if
    else if (l == 2) then
      if (m == -2) then
        ! R_2^-2 = sqrt(3)*eta*mu
        generate_y_lm = sqrt(3.0)*eta*mu
      else if (m == -1) then
        ! R_2^-1 = sqrt(3)*eta*xi
        generate_y_lm = sqrt(3.0)*eta*xi
      else if (m == 0) then
        ! R_2^0 = 1.5*xi**2 - 0.5
        generate_y_lm = 1.5*xi**2 - 0.5
      else if (m == 1) then
        ! R_2^1 = sqrt(3)*mu*xi
        generate_y_lm = sqrt(3.0)*mu*xi
      else if (m == 2) then
        ! R_2^2 = 0.5*sqrt(3)*(-eta**2 + mu**2)
        generate_y_lm = 0.5*sqrt(3.0)*(-eta**2 + mu**2)
      end if
    else if (l == 3) then
      if (m == -3) then
        ! R_3^-3 = sqrt(10)*eta*(-0.25*eta**2 + 0.75*mu**2)
        generate_y_lm = sqrt(10.0)*eta*(-0.25*eta**2 + 0.75*mu**2)
      else if (m == -2) then
        ! R_3^-2 = sqrt(15)*eta*mu*xi
        generate_y_lm = sqrt(15.0)*eta*mu*xi
      else if (m == -1) then
        ! R_3^-1 = sqrt(6)*eta*(1.25*xi**2 - 0.25)
        generate_y_lm = sqrt(6.0)*eta*(1.25*xi**2 - 0.25)
      else if (m == 0) then
        ! R_3^0 = xi*(2.5*xi**2 - 1.5)
        generate_y_lm = xi*(2.5*xi**2 - 1.5)
      else if (m == 1) then
        ! R_3^1 = sqrt(6)*mu*(1.25*xi**2 - 0.25)
        generate_y_lm = sqrt(6.0)*mu*(1.25*xi**2 - 0.25)
      else if (m == 2) then
        ! R_3^2 = 0.5*sqrt(15)*xi*(-eta**2 + mu**2)
        generate_y_lm = 0.5*sqrt(15.0)*xi*(-eta**2 + mu**2)
      else if (m == 3) then
        ! R_3^3 = sqrt(10)*mu*(-0.75*eta**2 + 0.25*mu**2)
        generate_y_lm = sqrt(10.0)*mu*(-0.75*eta**2 + 0.25*mu**2)
      end if
    else if (l == 4) then
      if (m == -4) then
        ! R_4^-4 = 0.5*sqrt(35)*eta*mu*(-eta**2 + mu**2)
        generate_y_lm = 0.5*sqrt(35.0)*eta*mu*(-eta**2 + mu**2)
      else if (m == -3) then
        ! R_4^-3 = sqrt(70)*eta*xi*(-0.25*eta**2 + 0.75*mu**2)
        generate_y_lm = sqrt(70.0)*eta*xi*(-0.25*eta**2 + 0.75*mu**2)
      else if (m == -2) then
        ! R_4^-2 = sqrt(5)*eta*mu*(3.5*xi**2 - 0.5)
        generate_y_lm = sqrt(5.0)*eta*mu*(3.5*xi**2 - 0.5)
      else if (m == -1) then
        ! R_4^-1 = sqrt(10)*eta*xi*(1.75*xi**2 - 0.75)
        generate_y_lm = sqrt(10.0)*eta*xi*(1.75*xi**2 - 0.75)
      else if (m == 0) then
        ! R_4^0 = 4.375*xi**4 - 3.75*xi**2 + 0.375
        generate_y_lm = 4.375*xi**4 - 3.75*xi**2 + 0.375
      else if (m == 1) then
        ! R_4^1 = sqrt(10)*mu*xi*(1.75*xi**2 - 0.75)
        generate_y_lm = sqrt(10.0)*mu*xi*(1.75*xi**2 - 0.75)
      else if (m == 2) then
        ! R_4^2 = -1.75*sqrt(5)*(eta - mu)*(eta + mu)*(xi**2 - 1.0/7)
        generate_y_lm = -1.75*sqrt(5.0)*(eta - mu)*(eta + mu)*(xi**2 - 1.0/7)
      else if (m == 3) then
        ! R_4^3 = sqrt(70)*mu*xi*(-0.75*eta**2 + 0.25*mu**2)
        generate_y_lm = sqrt(70.0)*mu*xi*(-0.75*eta**2 + 0.25*mu**2)
      else if (m == 4) then
        ! R_4^4 = sqrt(35)*(0.125*eta**4 - 0.75*eta**2*mu**2 + 0.125*mu**4)
        generate_y_lm = sqrt(35.0)*(0.125*eta**4 - 0.75*eta**2*mu**2 + 0.125*mu**4)
      end if
    else if (l == 5) then
      if (m == -5) then
        ! R_5^-5 = sqrt(14)*eta*(0.1875*eta**4 - 1.875*eta**2*mu**2 + 0.9375*mu**4)
        generate_y_lm = sqrt(14.0)*eta*(0.1875*eta**4 - 1.875*eta**2*mu**2 + 0.9375*mu**4)
      else if (m == -4) then
        ! R_5^-4 = 1.5*sqrt(35)*eta*mu*xi*(-eta**2 + mu**2)
        generate_y_lm = 1.5*sqrt(35.0)*eta*mu*xi*(-eta**2 + mu**2)
      else if (m == -3) then
        ! R_5^-3 = -1.6875*sqrt(70)*eta*(1.0/3*eta**2 - mu**2)*(xi - 1.0/3)*(xi + 1.0/3)
        generate_y_lm = -1.6875*sqrt(70.0)*eta*(1.0/3*eta**2 - mu**2)*(xi - 1.0/3)*(xi + 1.0/3)
      else if (m == -2) then
        ! R_5^-2 = sqrt(105)*eta*mu*xi*(1.5*xi**2 - 0.5)
        generate_y_lm = sqrt(105.0)*eta*mu*xi*(1.5*xi**2 - 0.5)
      else if (m == -1) then
        ! R_5^-1 = sqrt(15)*eta*(2.625*xi**4 - 1.75*xi**2 + 0.125)
        generate_y_lm = sqrt(15.0)*eta*(2.625*xi**4 - 1.75*xi**2 + 0.125)
      else if (m == 0) then
        ! R_5^0 = xi*(7.875*xi**4 - 8.75*xi**2 + 1.875)
        generate_y_lm = xi*(7.875*xi**4 - 8.75*xi**2 + 1.875)
      else if (m == 1) then
        ! R_5^1 = sqrt(15)*mu*(2.625*xi**4 - 1.75*xi**2 + 0.125)
        generate_y_lm = sqrt(15.0)*mu*(2.625*xi**4 - 1.75*xi**2 + 0.125)
      else if (m == 2) then
        ! R_5^2 = -0.75*sqrt(105)*xi*(eta - mu)*(eta + mu)*(xi**2 - 1.0/3)
        generate_y_lm = -0.75*sqrt(105.0)*xi*(eta - mu)*(eta + mu)*(xi**2 - 1.0/3)
      else if (m == 3) then
        ! R_5^3 = -1.6875*sqrt(70)*mu*(eta**2 - 1.0/3*mu**2)*(xi - 1.0/3)*(xi + 1.0/3)
        generate_y_lm = -1.6875*sqrt(70.0)*mu*(eta**2 - 1.0/3*mu**2)*(xi - 1.0/3)*(xi + 1.0/3)
      else if (m == 4) then
        ! R_5^4 = sqrt(35)*xi*(0.375*eta**4 - 2.25*eta**2*mu**2 + 0.375*mu**4)
        generate_y_lm = sqrt(35.0)*xi*(0.375*eta**4 - 2.25*eta**2*mu**2 + 0.375*mu**4)
      else if (m == 5) then
        ! R_5^5 = sqrt(14)*mu*(0.9375*eta**4 - 1.875*eta**2*mu**2 + 0.1875*mu**4)
        generate_y_lm = sqrt(14.0)*mu*(0.9375*eta**4 - 1.875*eta**2*mu**2 + 0.1875*mu**4)
      end if
    else if (l == 6) then
      if (m == -6) then
        ! R_6^-6 = sqrt(462)*eta*mu*(0.1875*eta**4 - 0.625*eta**2*mu**2 + 0.1875*mu**4)
        generate_y_lm = sqrt(462.0)*eta*mu*(0.1875*eta**4 - 0.625*eta**2*mu**2 + 0.1875*mu**4)
      else if (m == -5) then
        ! R_6^-5 = sqrt(154)*eta*xi*(0.1875*eta**4 - 1.875*eta**2*mu**2 + 0.9375*mu**4)
        generate_y_lm = sqrt(154.0)*eta*xi*(0.1875*eta**4 - 1.875*eta**2*mu**2 + 0.9375*mu**4)
      else if (m == -4) then
        ! R_6^-4 = -8.25*sqrt(7)*eta*mu*(eta - mu)*(eta + mu)*(xi**2 - 1.0/11)
        generate_y_lm = -8.25*sqrt(7.0)*eta*mu*(eta - mu)*(eta + mu)*(xi**2 - 1.0/11)
      else if (m == -3) then
        ! R_6^-3 = -2.0625*sqrt(210)*eta*xi*(1.0/3*eta**2 - mu**2)*(xi**2 - 3/11)
        generate_y_lm = -2.0625*sqrt(210.0)*eta*xi*(1.0/3*eta**2 - mu**2)*(xi**2 - 3.0/11)
      else if (m == -2) then
        ! R_6^-2 = sqrt(210)*eta*mu*(2.0625*xi**4 - 1.125*xi**2 + 0.0625)
        generate_y_lm = sqrt(210.0)*eta*mu*(2.0625*xi**4 - 1.125*xi**2 + 0.0625)
      else if (m == -1) then
        ! R_6^-1 = sqrt(21)*eta*xi*(4.125*xi**4 - 3.75*xi**2 + 0.625)
        generate_y_lm = sqrt(21.0)*eta*xi*(4.125*xi**4 - 3.75*xi**2 + 0.625)
      else if (m == 0) then
        ! R_6^0 = 14.4375*xi**6 - 19.6875*xi**4 + 6.5625*xi**2 - 0.3125
        generate_y_lm = 14.4375*xi**6 - 19.6875*xi**4 + 6.5625*xi**2 - 0.3125
      else if (m == 1) then
        ! R_6^1 = sqrt(21)*mu*xi*(4.125*xi**4 - 3.75*xi**2 + 0.625)
        generate_y_lm = sqrt(21.0)*mu*xi*(4.125*xi**4 - 3.75*xi**2 + 0.625)
      else if (m == 2) then
        ! R_6^2 = -1.03125*sqrt(210)*(eta - mu)*(eta + mu)*(xi**4 - 6/11*xi**2 + 1.0/33)
        generate_y_lm = -1.03125*sqrt(210.0)*(eta - mu)*(eta + mu)*(xi**4 - 6.0/11*xi**2 + 1.0/33)
      else if (m == 3) then
        ! R_6^3 = -2.0625*sqrt(210)*mu*xi*(eta**2 - 1.0/3*mu**2)*(xi**2 - 3/11)
        generate_y_lm = -2.0625*sqrt(210.0)*mu*xi*(eta**2 - 1.0/3*mu**2)*(xi**2 - 3.0/11)
      else if (m == 4) then
        ! R_6^4 = -8.25*sqrt(7)*(xi**2 - 1.0/11)*(-0.5*eta**2 + eta*mu + 0.5*mu**2)*(0.5*eta**2 + eta*mu - 0.5*mu**2)
        generate_y_lm = -8.25*sqrt(7.0)*(xi**2 - 1.0/11)*(-0.5*eta**2 + eta*mu + 0.5*mu**2)*(0.5*eta**2 + eta*mu - 0.5*mu**2)
      else if (m == 5) then
        ! R_6^5 = sqrt(154)*mu*xi*(0.9375*eta**4 - 1.875*eta**2*mu**2 + 0.1875*mu**4)
        generate_y_lm = sqrt(154.0)*mu*xi*(0.9375*eta**4 - 1.875*eta**2*mu**2 + 0.1875*mu**4)
      else if (m == 6) then
        ! R_6^6 = sqrt(462)*(-0.03125*eta**6 + 0.46875*eta**4*mu**2 - 0.46875*eta**2*mu**4 + 0.03125*mu**6)
        generate_y_lm = sqrt(462.0)*(-0.03125*eta**6 + 0.46875*eta**4*mu**2 - 0.46875*eta**2*mu**4 + 0.03125*mu**6)
      end if
    else if (l == 7) then
      if (m == -7) then
        ! R_7^-7 = sqrt(429)*eta*(-0.03125*eta**6 + 0.65625*eta**4*mu**2 - 1.09375*eta**2*mu**4 + 0.21875*mu**6)
        generate_y_lm = sqrt(429.0)*eta*(-0.03125*eta**6 + 0.65625*eta**4*mu**2 - 1.09375*eta**2*mu**4 + 0.21875*mu**6)
      else if (m == -6) then
        ! R_7^-6 = sqrt(6006)*eta*mu*xi*(0.1875*eta**4 - 0.625*eta**2*mu**2 + 0.1875*mu**4)
        generate_y_lm = sqrt(6006.0)*eta*mu*xi*(0.1875*eta**4 - 0.625*eta**2*mu**2 + 0.1875*mu**4)
      else if (m == -5) then
        ! R_7^-5 = 4.0625*sqrt(231)*eta*(xi**2 - 1.0/13)*(0.1*eta**4 - eta**2*mu**2 + 0.5*mu**4)
        generate_y_lm = 4.0625*sqrt(231.0)*eta*(xi**2 - 1.0/13)*(0.1*eta**4 - eta**2*mu**2 + 0.5*mu**4)
      else if (m == -4) then
        ! R_7^-4 = -3.25*sqrt(231)*eta*mu*xi*(eta - mu)*(eta + mu)*(xi**2 - 3/13)
        generate_y_lm = -3.25*sqrt(231.0)*eta*mu*xi*(eta - mu)*(eta + mu)*(xi**2 - 3.0/13)
      else if (m == -3) then
        ! R_7^-3 = -13.40625*sqrt(21)*eta*(1.0/3*eta**2 - mu**2)*(xi**4 - 6/13*xi**2 + 3/143)
        generate_y_lm = -13.40625*sqrt(21.0)*eta*(1.0/3*eta**2 - mu**2)*(xi**4 - 6.0/13*xi**2 + 3.0/143)
      else if (m == -2) then
        ! R_7^-2 = sqrt(42)*eta*mu*xi*(8.9375*xi**4 - 6.875*xi**2 + 0.9375)
        generate_y_lm = sqrt(42.0)*eta*mu*xi*(8.9375*xi**4 - 6.875*xi**2 + 0.9375)
      else if (m == -1) then
        ! R_7^-1 = sqrt(7)*eta*(13.40625*xi**6 - 15.46875*xi**4 + 4.21875*xi**2 - 0.15625)
        generate_y_lm = sqrt(7.0)*eta*(13.40625*xi**6 - 15.46875*xi**4 + 4.21875*xi**2 - 0.15625)
      else if (m == 0) then
        ! R_7^0 = xi*(26.8125*xi**6 - 43.3125*xi**4 + 19.6875*xi**2 - 2.1875)
        generate_y_lm = xi*(26.8125*xi**6 - 43.3125*xi**4 + 19.6875*xi**2 - 2.1875)
      else if (m == 1) then
        ! R_7^1 = sqrt(7)*mu*(13.40625*xi**6 - 15.46875*xi**4 + 4.21875*xi**2 - 0.15625)
        generate_y_lm = sqrt(7.0)*mu*(13.40625*xi**6 - 15.46875*xi**4 + 4.21875*xi**2 - 0.15625)
      else if (m == 2) then
        ! R_7^2 = -4.46875*sqrt(42)*xi*(eta - mu)*(eta + mu)*(xi**4 - 10.0/13.0*xi**2 + 15.0/143.0)
        generate_y_lm = -4.46875*sqrt(42.0)*xi*(eta - mu)*(eta + mu)*(xi**4 - 10.0/13.0*xi**2 + 15.0/143.0)
      else if (m == 3) then
        ! R_7^3 = -13.40625*sqrt(21)*mu*(eta**2 - 1.0/3*mu**2)*(xi**4 - 6/13*xi**2 + 3/143)
        generate_y_lm = -13.40625*sqrt(21.0)*mu*(eta**2 - 1.0/3*mu**2)*(xi**4 - 6.0/13*xi**2 + 3.0/143)
      else if (m == 4) then
        ! R_7^4 = -3.25*sqrt(231)*xi*(xi**2 - 3/13)*(-0.5*eta**2 + eta*mu + 0.5*mu**2)*(0.5*eta**2 + eta*mu - 0.5*mu**2)
        generate_y_lm = -3.25*sqrt(231.0)*xi*(xi**2 - 3.0/13)*(-0.5*eta**2 + eta*mu + 0.5*mu**2)*(0.5*eta**2 + eta*mu - 0.5*mu**2)
      else if (m == 5) then
        ! R_7^5 = 4.0625*sqrt(231)*mu*(xi**2 - 1.0/13)*(0.5*eta**4 - eta**2*mu**2 + 0.1*mu**4)
        generate_y_lm = 4.0625*sqrt(231.0)*mu*(xi**2 - 1.0/13)*(0.5*eta**4 - eta**2*mu**2 + 0.1*mu**4)
      else if (m == 6) then
        ! R_7^6 = sqrt(6006)*xi*(-0.03125*eta**6 + 0.46875*eta**4*mu**2 - 0.46875*eta**2*mu**4 + 0.03125*mu**6)
        generate_y_lm = sqrt(6006.0)*xi*(-0.03125*eta**6 + 0.46875*eta**4*mu**2 - 0.46875*eta**2*mu**4 + 0.03125*mu**6)
      else if (m == 7) then
        ! R_7^7 = sqrt(429)*mu*(-0.21875*eta**6 + 1.09375*eta**4*mu**2 - 0.65625*eta**2*mu**4 + 0.03125*mu**6)
        generate_y_lm = sqrt(429.0)*mu*(-0.21875*eta**6 + 1.09375*eta**4*mu**2 - 0.65625*eta**2*mu**4 + 0.03125*mu**6)
      end if
    else
      print *, 'Order l=', l, ' not implemented'
      stop
    end if

  end function generate_y_lm

end module angle
