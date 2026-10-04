.class public final Lcom/alipay/mobilesecuritysdk/model/a;
.super Ljava/lang/Object;


# instance fields
.field private final a:I

.field private b:Lcom/alipay/mobilesecuritysdk/model/b;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/16 v0, 0x8

    iput v0, p0, Lcom/alipay/mobilesecuritysdk/model/a;->a:I

    new-instance v0, Lcom/alipay/mobilesecuritysdk/model/b;

    invoke-direct {v0}, Lcom/alipay/mobilesecuritysdk/model/b;-><init>()V

    iput-object v0, p0, Lcom/alipay/mobilesecuritysdk/model/a;->b:Lcom/alipay/mobilesecuritysdk/model/b;

    return-void
.end method

.method private a(Landroid/content/Context;Ljava/util/List;)Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            "Ljava/util/List",
            "<",
            "Ljava/lang/String;",
            ">;)",
            "Ljava/lang/String;"
        }
    .end annotation

    invoke-static {p1}, Lcom/alipay/mobilesecuritysdk/model/a;->a(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/a;->b:Lcom/alipay/mobilesecuritysdk/model/b;

    iput-object p2, v1, Lcom/alipay/mobilesecuritysdk/model/b;->a:Ljava/util/List;

    iget-object v1, p0, Lcom/alipay/mobilesecuritysdk/model/a;->b:Lcom/alipay/mobilesecuritysdk/model/b;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v3

    invoke-virtual {v3}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2, v0}, Lcom/alipay/mobilesecuritysdk/model/b;->b(Ljava/lang/String;Ljava/util/List;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static a([B)Ljava/lang/String;
    .locals 5

    :try_start_0
    const-string v0, "X.509"

    invoke-static {v0}, Ljava/security/cert/CertificateFactory;->getInstance(Ljava/lang/String;)Ljava/security/cert/CertificateFactory;

    move-result-object v0

    new-instance v1, Ljava/io/ByteArrayInputStream;

    invoke-direct {v1, p0}, Ljava/io/ByteArrayInputStream;-><init>([B)V

    invoke-virtual {v0, v1}, Ljava/security/cert/CertificateFactory;->generateCertificate(Ljava/io/InputStream;)Ljava/security/cert/Certificate;

    move-result-object v0

    check-cast v0, Ljava/security/cert/X509Certificate;

    invoke-virtual {v0}, Ljava/security/cert/X509Certificate;->getPublicKey()Ljava/security/PublicKey;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v0, "modulus"

    invoke-virtual {v3, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v4

    const-string v0, "\n"

    add-int/lit8 v1, v4, 0x8

    invoke-virtual {v3, v0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v1

    const-string v0, ","

    add-int/lit8 v2, v4, 0x8

    invoke-virtual {v3, v0, v2}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    const/4 v2, -0x1

    if-gez v1, :cond_1

    if-lez v0, :cond_1

    :cond_0
    :goto_0
    if-gez v0, :cond_4

    add-int/lit8 v0, v4, 0x8

    invoke-virtual {v3, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    :goto_1
    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_2
    return-object v0

    :cond_1
    if-gez v0, :cond_2

    if-lez v1, :cond_2

    move v0, v1

    goto :goto_0

    :cond_2
    if-ge v1, v0, :cond_3

    move v0, v1

    goto :goto_0

    :cond_3
    if-lt v0, v1, :cond_0

    move v0, v2

    goto :goto_0

    :cond_4
    add-int/lit8 v1, v4, 0x8

    invoke-virtual {v3, v1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    goto :goto_1

    :catch_0
    move-exception v0

    const-string v1, "ALP"

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x0

    goto :goto_2
.end method

.method public static a(Landroid/content/Context;)Ljava/util/List;
    .locals 13
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List",
            "<",
            "Lcom/alipay/mobilesecuritysdk/datainfo/c;",
            ">;"
        }
    .end annotation

    const/4 v8, 0x0

    const/4 v12, 0x2

    const/4 v9, 0x1

    new-instance v7, Ljava/util/ArrayList;

    invoke-direct {v7}, Ljava/util/ArrayList;-><init>()V

    const/4 v10, 0x0

    :try_start_0
    new-instance v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;

    invoke-direct {v11}, Lcom/alipay/mobilesecuritysdk/datainfo/c;-><init>()V

    new-instance v0, Ljava/util/Date;

    invoke-direct {v0}, Ljava/util/Date;-><init>()V

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->b:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->e:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->f:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->d:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->c:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->h:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->i:Ljava/lang/String;

    const-string v0, ""

    iput-object v0, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->g:Ljava/lang/String;

    const-string v0, "location"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/location/LocationManager;

    const-string v1, "network"

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->isProviderEnabled(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_4

    new-instance v5, Lcom/alipay/mobilesecuritysdk/model/c;

    invoke-direct {v5}, Lcom/alipay/mobilesecuritysdk/model/c;-><init>()V

    const-string v1, "network"

    const-wide/32 v2, 0x493e0

    const/4 v4, 0x0

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v6

    invoke-virtual/range {v0 .. v6}, Landroid/location/LocationManager;->requestLocationUpdates(Ljava/lang/String;JFLandroid/location/LocationListener;Landroid/os/Looper;)V

    invoke-virtual {v0, v5}, Landroid/location/LocationManager;->removeUpdates(Landroid/location/LocationListener;)V

    const-string v1, "network"

    invoke-virtual {v0, v1}, Landroid/location/LocationManager;->getLastKnownLocation(Ljava/lang/String;)Landroid/location/Location;

    move-result-object v0

    if-eqz v0, :cond_4

    invoke-virtual {v0}, Landroid/location/Location;->getLatitude()D

    move-result-wide v1

    invoke-virtual {v11, v1, v2}, Lcom/alipay/mobilesecuritysdk/datainfo/c;->b(D)V

    invoke-virtual {v0}, Landroid/location/Location;->getLongitude()D

    move-result-wide v0

    invoke-virtual {v11, v0, v1}, Lcom/alipay/mobilesecuritysdk/datainfo/c;->a(D)V

    move v1, v9

    :goto_0
    const-string v0, "phone"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/telephony/TelephonyManager;

    invoke-virtual {v0}, Landroid/telephony/TelephonyManager;->getPhoneType()I

    move-result v2

    if-ne v2, v12, :cond_2

    sget-object v2, Lcom/alipay/mobilesecuritysdk/constant/c;->m:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v2}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v2

    iput-object v2, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->g:Ljava/lang/String;

    if-nez v1, :cond_0

    const/4 v1, 0x2

    invoke-static {v0, v11, v1}, Lcom/alipay/mobilesecuritysdk/model/a;->a(Landroid/telephony/TelephonyManager;Lcom/alipay/mobilesecuritysdk/datainfo/c;I)V

    :cond_0
    :goto_1
    invoke-static {p0}, Lcom/alipay/mobilesecuritysdk/model/a;->c(Landroid/content/Context;)Ljava/util/List;

    move-result-object v0

    if-eqz v0, :cond_1

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    if-lez v1, :cond_1

    iput-object v0, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->a:Ljava/util/List;

    :cond_1
    invoke-interface {v7, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    invoke-interface {v7}, Ljava/util/List;->size()I

    move-result v0

    if-lez v0, :cond_3

    move-object v0, v7

    :goto_2
    return-object v0

    :cond_2
    sget-object v1, Lcom/alipay/mobilesecuritysdk/constant/c;->s:Lcom/alipay/mobilesecuritysdk/constant/c;

    invoke-virtual {v1}, Lcom/alipay/mobilesecuritysdk/constant/c;->a()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v11, Lcom/alipay/mobilesecuritysdk/datainfo/c;->g:Ljava/lang/String;

    const/4 v1, 0x1

    invoke-static {v0, v11, v1}, Lcom/alipay/mobilesecuritysdk/model/a;->a(Landroid/telephony/TelephonyManager;Lcom/alipay/mobilesecuritysdk/datainfo/c;I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception v0

    const-string v1, "ALP"

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    move-object v0, v8

    goto :goto_2

    :cond_3
    move-object v0, v8

    goto :goto_2

    :cond_4
    move v1, v10

    goto :goto_0
.end method

.method private static a(Landroid/telephony/TelephonyManager;Lcom/alipay/mobilesecuritysdk/datainfo/c;I)V
    .locals 11

    const-wide v8, 0x40cc200000000000L    # 14400.0

    const-string v4, ""

    const-string v3, ""

    const-string v2, ""

    const-string v1, ""

    const/4 v0, 0x2

    if-ne p2, v0, :cond_0

    :try_start_0
    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getCellLocation()Landroid/telephony/CellLocation;

    move-result-object v0

    check-cast v0, Landroid/telephony/cdma/CdmaCellLocation;

    if-eqz v0, :cond_1

    iget-object v5, p1, Lcom/alipay/mobilesecuritysdk/datainfo/c;->d:Ljava/lang/String;

    invoke-static {v5}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_1

    iget-object v5, p1, Lcom/alipay/mobilesecuritysdk/datainfo/c;->c:Ljava/lang/String;

    invoke-static {v5}, Lcom/alipay/mobilesecuritysdk/util/a;->a(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_1

    invoke-virtual {v0}, Landroid/telephony/cdma/CdmaCellLocation;->getNetworkId()I

    move-result v5

    invoke-static {v5}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getNetworkOperator()Ljava/lang/String;

    move-result-object v5

    const/4 v6, 0x0

    const/4 v7, 0x3

    invoke-virtual {v5, v6, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0}, Landroid/telephony/cdma/CdmaCellLocation;->getSystemId()I

    move-result v5

    invoke-static {v5}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0}, Landroid/telephony/cdma/CdmaCellLocation;->getBaseStationId()I

    move-result v5

    invoke-static {v5}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0}, Landroid/telephony/cdma/CdmaCellLocation;->getBaseStationLatitude()I

    move-result v5

    int-to-double v5, v5

    div-double/2addr v5, v8

    invoke-virtual {p1, v5, v6}, Lcom/alipay/mobilesecuritysdk/datainfo/c;->b(D)V

    invoke-virtual {v0}, Landroid/telephony/cdma/CdmaCellLocation;->getBaseStationLongitude()I

    move-result v0

    int-to-double v5, v0

    div-double/2addr v5, v8

    invoke-virtual {p1, v5, v6}, Lcom/alipay/mobilesecuritysdk/datainfo/c;->a(D)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-object v0, v1

    move-object v1, v2

    move-object v2, v3

    move-object v3, v4

    :goto_0
    iput-object v3, p1, Lcom/alipay/mobilesecuritysdk/datainfo/c;->h:Ljava/lang/String;

    iput-object v2, p1, Lcom/alipay/mobilesecuritysdk/datainfo/c;->i:Ljava/lang/String;

    iput-object v1, p1, Lcom/alipay/mobilesecuritysdk/datainfo/c;->e:Ljava/lang/String;

    iput-object v0, p1, Lcom/alipay/mobilesecuritysdk/datainfo/c;->f:Ljava/lang/String;

    return-void

    :catch_0
    move-exception v0

    move-object v10, v0

    move-object v0, v1

    move-object v1, v2

    move-object v2, v3

    move-object v3, v4

    move-object v4, v10

    const-string v5, "gettelphonetype PHONE_TYPE_CDMA"

    invoke-virtual {v4}, Ljava/lang/Exception;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v4

    invoke-static {v5, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :cond_0
    :try_start_1
    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getCellLocation()Landroid/telephony/CellLocation;

    move-result-object v0

    check-cast v0, Landroid/telephony/gsm/GsmCellLocation;

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getNetworkOperator()Ljava/lang/String;

    move-result-object v5

    const/4 v6, 0x0

    const/4 v7, 0x3

    invoke-virtual {v5, v6, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {p0}, Landroid/telephony/TelephonyManager;->getNetworkOperator()Ljava/lang/String;

    move-result-object v5

    const/4 v6, 0x3

    const/4 v7, 0x5

    invoke-virtual {v5, v6, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0}, Landroid/telephony/gsm/GsmCellLocation;->getCid()I

    move-result v5

    invoke-static {v5}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0}, Landroid/telephony/gsm/GsmCellLocation;->getLac()I

    move-result v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    move-result-object v0

    move-object v1, v2

    move-object v2, v3

    move-object v3, v4

    goto :goto_0

    :catch_1
    move-exception v0

    move-object v10, v0

    move-object v0, v2

    move-object v2, v3

    move-object v3, v4

    move-object v4, v10

    const-string v5, "gettelphonetype"

    invoke-virtual {v4}, Ljava/lang/Exception;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v4

    invoke-static {v5, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    move-object v10, v1

    move-object v1, v0

    move-object v0, v10

    goto :goto_0

    :cond_1
    move-object v0, v1

    move-object v1, v2

    move-object v2, v3

    move-object v3, v4

    goto :goto_0
.end method

.method public static b(Landroid/content/Context;)Ljava/util/List;
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List",
            "<",
            "Lcom/alipay/mobilesecuritysdk/datainfo/a;",
            ">;"
        }
    .end annotation

    :try_start_0
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v2

    const/16 v0, 0x1000

    invoke-virtual {v2, v0}, Landroid/content/pm/PackageManager;->getInstalledPackages(I)Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_0
    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_1

    move-object v0, v1

    :goto_1
    return-object v0

    :cond_1
    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/pm/PackageInfo;

    const-string v4, "android.permission.READ_SMS"

    iget-object v5, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v2, v4, v5}, Landroid/content/pm/PackageManager;->checkPermission(Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    if-eqz v4, :cond_2

    const-string v4, "android.permission.RECEIVE_SMS"

    iget-object v5, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v2, v4, v5}, Landroid/content/pm/PackageManager;->checkPermission(Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    if-nez v4, :cond_0

    :cond_2
    const-string v4, "android.permission.SEND_SMS"

    iget-object v5, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v2, v4, v5}, Landroid/content/pm/PackageManager;->checkPermission(Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    if-eqz v4, :cond_3

    const-string v4, "android.permission.INTERNET"

    iget-object v5, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-virtual {v2, v4, v5}, Landroid/content/pm/PackageManager;->checkPermission(Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    if-nez v4, :cond_0

    :cond_3
    new-instance v4, Lcom/alipay/mobilesecuritysdk/datainfo/a;

    invoke-direct {v4}, Lcom/alipay/mobilesecuritysdk/datainfo/a;-><init>()V

    iget-object v5, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    iput-object v5, v4, Lcom/alipay/mobilesecuritysdk/datainfo/a;->a:Ljava/lang/String;

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    const/16 v5, 0x40

    invoke-virtual {v2, v0, v5}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v0

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;

    const/4 v5, 0x0

    aget-object v0, v0, v5

    invoke-virtual {v0}, Landroid/content/pm/Signature;->toByteArray()[B

    move-result-object v0

    invoke-static {v0}, Lcom/alipay/mobilesecuritysdk/model/a;->a([B)Ljava/lang/String;

    move-result-object v0

    iput-object v0, v4, Lcom/alipay/mobilesecuritysdk/datainfo/a;->b:Ljava/lang/String;

    invoke-virtual {v4}, Lcom/alipay/mobilesecuritysdk/datainfo/a;->a()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-interface {v1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v1, "ALP"

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v0, 0x0

    goto :goto_1
.end method

.method private static c(Landroid/content/Context;)Ljava/util/List;
    .locals 7
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/content/Context;",
            ")",
            "Ljava/util/List",
            "<",
            "Lcom/alipay/mobilesecuritysdk/datainfo/f;",
            ">;"
        }
    .end annotation

    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    const-string v0, "wifi"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/wifi/WifiManager;

    :try_start_0
    invoke-virtual {v0}, Landroid/net/wifi/WifiManager;->isWifiEnabled()Z

    move-result v2

    if-eqz v2, :cond_2

    invoke-virtual {v0}, Landroid/net/wifi/WifiManager;->getConnectionInfo()Landroid/net/wifi/WifiInfo;

    move-result-object v2

    new-instance v3, Lcom/alipay/mobilesecuritysdk/datainfo/f;

    invoke-direct {v3}, Lcom/alipay/mobilesecuritysdk/datainfo/f;-><init>()V

    invoke-virtual {v2}, Landroid/net/wifi/WifiInfo;->getBSSID()Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Lcom/alipay/mobilesecuritysdk/datainfo/f;->a:Ljava/lang/String;

    invoke-virtual {v2}, Landroid/net/wifi/WifiInfo;->getSSID()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->getBytes()[B

    move-result-object v4

    const/16 v5, 0x8

    invoke-static {v4, v5}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v4

    iput-object v4, v3, Lcom/alipay/mobilesecuritysdk/datainfo/f;->c:Ljava/lang/String;

    invoke-virtual {v2}, Landroid/net/wifi/WifiInfo;->getRssi()I

    move-result v4

    iput v4, v3, Lcom/alipay/mobilesecuritysdk/datainfo/f;->b:I

    const/4 v4, 0x1

    iput-boolean v4, v3, Lcom/alipay/mobilesecuritysdk/datainfo/f;->d:Z

    invoke-interface {v1, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    invoke-virtual {v0}, Landroid/net/wifi/WifiManager;->getScanResults()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_0
    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-nez v0, :cond_1

    move-object v0, v1

    :goto_1
    return-object v0

    :cond_1
    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/net/wifi/ScanResult;

    iget-object v4, v0, Landroid/net/wifi/ScanResult;->BSSID:Ljava/lang/String;

    invoke-virtual {v2}, Landroid/net/wifi/WifiInfo;->getBSSID()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_0

    iget-object v4, v0, Landroid/net/wifi/ScanResult;->SSID:Ljava/lang/String;

    invoke-virtual {v2}, Landroid/net/wifi/WifiInfo;->getSSID()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_0

    new-instance v4, Lcom/alipay/mobilesecuritysdk/datainfo/f;

    invoke-direct {v4}, Lcom/alipay/mobilesecuritysdk/datainfo/f;-><init>()V

    iget-object v5, v0, Landroid/net/wifi/ScanResult;->BSSID:Ljava/lang/String;

    iput-object v5, v4, Lcom/alipay/mobilesecuritysdk/datainfo/f;->a:Ljava/lang/String;

    iget-object v5, v0, Landroid/net/wifi/ScanResult;->SSID:Ljava/lang/String;

    invoke-virtual {v5}, Ljava/lang/String;->getBytes()[B

    move-result-object v5

    const/16 v6, 0x8

    invoke-static {v5, v6}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v5

    iput-object v5, v4, Lcom/alipay/mobilesecuritysdk/datainfo/f;->c:Ljava/lang/String;

    iget v0, v0, Landroid/net/wifi/ScanResult;->level:I

    iput v0, v4, Lcom/alipay/mobilesecuritysdk/datainfo/f;->b:I

    const/4 v0, 0x0

    iput-boolean v0, v4, Lcom/alipay/mobilesecuritysdk/datainfo/f;->d:Z

    invoke-interface {v1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v1, "GetWifiInfos"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0}, Ljava/lang/Exception;->getLocalizedMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    const/4 v0, 0x0

    goto :goto_1
.end method
