module testPhysicalTensors

using
    MutableTypes,
    PhysicalSystemsOfUnits,
    PhysicalFields,
    PhysicalScalars,
    PhysicalVectors,
    PhysicalTensors

const
    UtoString = PhysicalSystemsOfUnits.toString
    StoString = PhysicalScalars.toString
    VtoString = PhysicalVectors.toString
    TtoString = PhysicalTensors.toString

export
    run

function run()
    format = 'F'
    println("Test the get and set operators via [].")
    a = newPhysicalTensor(3, 3, SI_VELOCITY)
    println("A new 3x3 matrix has values: ")
    println(TtoString(a; format))
    x = 0.0
    for i in 1:3
        for j in 1:3
            x += 1.0
            a[i,j] = PhysicalScalar(MReal(x), a.u)
        end
    end
    println("that are reassigned to have entries of")
    println(TtoString(a; format))
    println()
    println("Check printing of large matrices:")
    b = newPhysicalTensor(15, 15, KILOGRAM)
    x = 1.0
    for i in 1:b.r
        for j in 1:b.c
            x -= 0.01
            b[i,j] = PhysicalScalar(MReal(x), KILOGRAM)
        end
    end
    println(TtoString(b))
    println()
    println(TtoString(b; format))
    println()
    println("Check printing of matrices, largest before truncating:")
    c = newPhysicalTensor(10, 10, KILOGRAM)
    for i in 1:c.r
        for j in 1:c.c
            c[i,j] = b[i,j]
        end
    end
    println(TtoString(c; format))
    d = newPhysicalTensor(6, 6, KILOGRAM)
    for i in 1:d.r
        for j in 1:d.c
            d[i,j] = b[i,j]
        end
    end
    println()
    format = 'E'
    println(TtoString(d; format))
    println()
    println("Next dimension smaller:")
    e = newPhysicalTensor(9, 9, KILOGRAM)
    for i in 1:e.r
        for j in 1:e.c
            e[i,j] = b[i,j]
        end
    end
    format = 'F'
    println(TtoString(e; format))
    r = newPhysicalTensor(5, 5, KILOGRAM)
    for i in 1:r.r
        for j in 1:r.c
            r[i,j] = b[i,j]
        end
    end
    format = 'E'
    println(TtoString(r; format))
    println()
    println("Check out the printing of short-fat matrices:")
    g = newPhysicalTensor(3, 12, KILOGRAM)
    for i in 1:g.r
        for j in 1:g.c
            g[i,j] = b[i,j]
        end
    end
    format = 'F'
    println(TtoString(g; format))
    format = 'E'
    println(TtoString(g; format))
    println()
    println("Check out the printing of tall-skiny matrices:")
    h = newPhysicalTensor(12, 3, KILOGRAM)
    for i in 1:h.r
        for j in 1:h.c
            h[i,j] = b[i,j]
        end
    end
    format = 'F'
    println(TtoString(h; format))
    println()
    format = 'E'
    println(TtoString(h; format))
    println()
    println("Test out the various matrix functions,")
    println("where tensor 'a' has entries of")
    println(TtoString(a; format))
    b = newPhysicalTensor(3, 3, CGS_VELOCITY)
    x = 10.0
    for i in 1:3
        for j in 1:3
            x -= 1.0
            b[i,j] = PhysicalScalar(MReal(x), b.u)
        end
    end
    println("while a tensor 'b' has entries of")
    println(TtoString(b; format))
    y = PhysicalScalar(MReal(??), CENTIMETER)
    w = newPhysicalVector(3, CGS_DIMENSIONLESS)
    z = newPhysicalVector(3, CGS_DIMENSIONLESS)
    x = 1.0
    for i in 1:3
        x += 2.0
        w[i] = PhysicalScalar(MReal(x-2.0), CGS_DIMENSIONLESS)
        z[i] = PhysicalScalar(MReal(x), CGS_DIMENSIONLESS)
    end
    println("along with scalar")
    println("y = ", StoString(y))
    println("and vectors")
    println("w = ", VtoString(w))
    println("z = ", VtoString(z))
    println()
    println("Note: Pay attention to the units in these answers.")
    println("w ??? z = \n", TtoString(tensorProduct(w,z)))
    println("-b = \n", TtoString(-b))
    println("a + b = \n", TtoString(a+b))
    println("a - b = \n", TtoString(a-b))
    println("a * b = \n", TtoString(a*b))
    println("b * z = ", VtoString(b*z))
    println("y * a = \n", TtoString(y*a))
    println("a / y = \n", TtoString(a/y))
    println("||a|| = ", StoString(norm(a)))
    println("tr a  = ", StoString(tr(a)))
    println("det a = ", StoString(det(a)))
    println("a??? = \n", TtoString(transpose(a)))
    println("The following should blow up because det(a) = 0.0.")
    println("a????? = \n", TtoString(inv(a)))
    println()
    c = newPhysicalTensor(3, 3, SI_COMPLIANCE)
    println("A new matrix 'c' has values of: ")
    c[1,1] = PhysicalScalar(MReal(3.0), SI_COMPLIANCE)
    c[1,2] = PhysicalScalar(MReal(2.0), SI_COMPLIANCE)
    c[1,3] = PhysicalScalar(MReal(1.0), SI_COMPLIANCE)
    c[2,1] = PhysicalScalar(MReal(-3.0), SI_COMPLIANCE)
    c[2,2] = PhysicalScalar(MReal(5.0), SI_COMPLIANCE)
    c[2,3] = PhysicalScalar(MReal(-1.0), SI_COMPLIANCE)
    c[3,1] = PhysicalScalar(MReal(0.0), SI_COMPLIANCE)
    c[3,2] = PhysicalScalar(MReal(1.0), SI_COMPLIANCE)
    c[3,3] = PhysicalScalar(MReal(5.0), SI_COMPLIANCE)
    println(TtoString(c))
    println("det c = ", StoString(det(c)))
    cInv = inv(c)
    println("c????? = \n", TtoString(cInv))
    println("c*c????? = \n", TtoString(c*cInv))
    println()
    println("Let ??? denote Lagrangian and ??? denote Eulerian.")
    println()
    println("A Gram-Schmidt factorization of the 3x3 matrix c produces:")
    (qL, r) = qr(c)
    println("Q??? from a QR (Gram-Schmidt) factorization of matrix c is")
    println(TtoString(qL))
    println("R from a QR (Gram-Schmidt) factorization of matrix c is")
    println(TtoString(r))
    println("whose product must return matrix c as a first check")
    println(TtoString(qL*r))
    println("while Q???Q?????? must return the identity matrix as a second check")
    println(TtoString(qL*transpose(qL)))
    println()
    println("Likewise, L from a LQ factorization of matrix c is")
    (l, qE) = lq(c)
    println(TtoString(l))
    println("whose associated orthogonal matrix Q??? is")
    println(TtoString(qE))
    println("whose product must return matrix c as a first check")
    println(TtoString(l*qE))
    println("while Q???Q?????? must return the identity matrix as a second check")
    println(TtoString(qE*transpose(qE)))
    println("Note that Q???Q??? = ")
    println(TtoString(qE*qL))
    println()
    println("A Gram-Schmidt factorization of a 2x2 matrix d:")
    d = newPhysicalTensor(2, 2, SI_COMPLIANCE)
    d[1,1] = c[1,1]
    d[1,2] = c[1,2]
    d[2,1] = c[2,1]
    d[2,2] = c[2,2]
    println("Matrix d has components:")
    println(TtoString(d))
    (qL, r) = qr(d)
    println("Q??? from a QR (Gram-Schmidt) factorization of matrix d is")
    println(TtoString(qL))
    println("R from a QR (Gram-Schmidt) factorization of matrix d is")
    println(TtoString(r))
    println("whose product must return matrix d as a first check")
    println(TtoString(qL*r))
    println("while Q???Q?????? must return the identity matrix as a second check")
    println(TtoString(qL*transpose(qL)))
    println()
    println("Likewise, L from a LQ factorization of matrix d is")
    (l, qE) = lq(d)
    println(TtoString(l))
    println("whose associated orthogonal matrix Q??? is")
    println(TtoString(qE))
    println("whose product must return matrix d as a first check")
    println(TtoString(l*qE))
    println("while Q???Q?????? must return the identity matrix as a second check")
    println(TtoString(qE*transpose(qE)))
    println("Note that Q???Q??? = ")
    println(TtoString(qE*qL))
    println()
    println("Testing the solution for a linear system of equations Ax = b")
    A = newPhysicalTensor(3, 3, SI_MASS)
    A[1,1] = PhysicalScalar(MReal(5), SI_MASS)
    A[1,2] = PhysicalScalar(MReal(3), SI_MASS)
    A[1,3] = PhysicalScalar(MReal(-1), SI_MASS)
    A[2,1] = PhysicalScalar(MReal(-2), SI_MASS)
    A[2,2] = PhysicalScalar(MReal(4), SI_MASS)
    A[2,3] = PhysicalScalar(MReal(1), SI_MASS)
    A[3,1] = PhysicalScalar(MReal(-4), SI_MASS)
    A[3,2] = PhysicalScalar(MReal(2), SI_MASS)
    A[3,3] = PhysicalScalar(MReal(6), SI_MASS)
    b = newPhysicalVector(3, SI_FORCE)
    b[1] = PhysicalScalar(MReal(7), SI_FORCE)
    b[2] = PhysicalScalar(MReal(3), SI_FORCE)
    b[3] = PhysicalScalar(MReal(4), SI_FORCE)
    x = A \ b
    println("where A = ")
    println(TtoString(A))
    println("and b = ")
    println(VtoString(b))
    println("has a solution of ")
    println(VtoString(x))
    println()
    println("Test type ArrayOfPhysicalTensors:")
    entries = 5
    rows = 2
    cols = 3
    m??? = newPhysicalTensor(rows, cols, CENTIMETER)
    m???[1,1] = PhysicalScalar(MReal(1), CENTIMETER)
    m???[1,2] = PhysicalScalar(MReal(2), CENTIMETER)
    m???[1,3] = PhysicalScalar(MReal(3), CENTIMETER)
    m???[2,1] = PhysicalScalar(MReal(4), CENTIMETER)
    m???[2,2] = PhysicalScalar(MReal(5), CENTIMETER)
    m???[2,3] = PhysicalScalar(MReal(6), CENTIMETER)
    array = newArrayOfPhysicalTensors(entries, m???)
    n = PhysicalScalar(MReal(6), CENTIMETER)
    one = PhysicalScalar(MReal(1), CENTIMETER)
    for i in 2:entries
        m??? = newPhysicalTensor(rows, cols, CENTIMETER)
        n = n + one
        m???[1,1] = n
        n = n + one
        m???[1,2] = n
        n = n + one
        m???[1,3] = n
        n = n + one
        m???[2,1] = n
        n = n + one
        m???[2,2] = n
        n = n + one
        m???[2,3] = n
        array[i] = m???
    end
    println("This array of matrices has a length of ", string(array.e), ".")
    for i in 1:entries
        m??? = array[i]
        println("array[", string(i), "] = \n", TtoString(m???))
    end
    array[3] = newPhysicalTensor(rows, cols, CENTIMETER)
    println("resetting the third entry to zeros, one has")
    println("array[3] = \n", TtoString(array[3]))
    println()
    println("If these answers make sense, then this test passes.")
    return nothing
end

end  # module testPhysicalFields
