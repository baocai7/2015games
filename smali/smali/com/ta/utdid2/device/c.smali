.class public final Lcom/ta/utdid2/device/c;
.super Ljava/lang/Object;


# static fields
.field static final a:Ljava/lang/String; = "dxCRMxhQkdGePGnp"

.field static final b:Ljava/lang/String; = "mqBRboGZkQPcAkyk"

.field private static final c:Ljava/lang/String; = "d6fc3a4a06adbde89223bvefedc24fecde188aaa9161"

.field private static final e:Ljava/lang/Object;

.field private static f:Lcom/ta/utdid2/device/c; = null

.field private static final l:Ljava/lang/String; = ".DataStorage"

.field private static final m:Ljava/lang/String; = "ContextData"

.field private static final o:Ljava/lang/String;

.field private static final p:Ljava/lang/String; = "Alvin2"


# instance fields
.field private d:Landroid/content/Context;

.field private g:Ljava/lang/String;

.field private h:Lcom/ta/utdid2/device/d;

.field private i:Ljava/lang/String;

.field private j:Ljava/lang/String;

.field private k:Lcom/ta/utdid2/core/persistent/c;

.field private n:Lcom/ta/utdid2/core/persistent/c;

.field private q:Ljava/util/regex/Pattern;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    sput-object v0, Lcom/ta/utdid2/device/c;->e:Ljava/lang/Object;

    const/4 v0, 0x0

    sput-object v0, Lcom/ta/utdid2/device/c;->f:Lcom/ta/utdid2/device/c;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, ".UTSystemConfig"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v1, Ljava/io/File;->separator:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "Global"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/ta/utdid2/device/c;->o:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>(Landroid/content/Context;)V
    .locals 5

    const/4 v4, 0x1

    const/4 v3, 0x0

    const/4 v1, 0x0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object v1, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    iput-object v1, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    iput-object v1, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    const-string v0, "xx_utdid_key"

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->i:Ljava/lang/String;

    const-string v0, "xx_utdid_domain"

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->j:Ljava/lang/String;

    iput-object v1, p0, Lcom/ta/utdid2/device/c;->k:Lcom/ta/utdid2/core/persistent/c;

    iput-object v1, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v0, "[^0-9a-zA-Z=/+]+"

    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->q:Ljava/util/regex/Pattern;

    iput-object p1, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    new-instance v0, Lcom/ta/utdid2/core/persistent/c;

    sget-object v1, Lcom/ta/utdid2/device/c;->o:Ljava/lang/String;

    const-string v2, "Alvin2"

    invoke-direct {v0, p1, v1, v2}, Lcom/ta/utdid2/core/persistent/c;-><init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    new-instance v0, Lcom/ta/utdid2/core/persistent/c;

    const-string v1, ".DataStorage"

    const-string v2, "ContextData"

    invoke-direct {v0, p1, v1, v2}, Lcom/ta/utdid2/core/persistent/c;-><init>(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->k:Lcom/ta/utdid2/core/persistent/c;

    new-instance v0, Lcom/ta/utdid2/device/d;

    invoke-direct {v0}, Lcom/ta/utdid2/device/d;-><init>()V

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    const-string v0, "K_%d"

    new-array v1, v4, [Ljava/lang/Object;

    iget-object v2, p0, Lcom/ta/utdid2/device/c;->i:Ljava/lang/String;

    invoke-static {v2}, Lcom/ta/utdid2/android/utils/f;->b(Ljava/lang/String;)I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v3

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->i:Ljava/lang/String;

    const-string v0, "D_%d"

    new-array v1, v4, [Ljava/lang/Object;

    iget-object v2, p0, Lcom/ta/utdid2/device/c;->j:Ljava/lang/String;

    invoke-static {v2}, Lcom/ta/utdid2/android/utils/f;->b(Ljava/lang/String;)I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v3

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->j:Ljava/lang/String;

    return-void
.end method

.method private static a(Lcom/ta/utdid2/device/a;)J
    .locals 5

    if-eqz p0, :cond_0

    const-string v0, "%s%s%s%s%s"

    const/4 v1, 0x5

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    iget-object v3, p0, Lcom/ta/utdid2/device/a;->d:Ljava/lang/String;

    aput-object v3, v1, v2

    const/4 v2, 0x1

    iget-object v3, p0, Lcom/ta/utdid2/device/a;->c:Ljava/lang/String;

    aput-object v3, v1, v2

    const/4 v2, 0x2

    iget-wide v3, p0, Lcom/ta/utdid2/device/a;->e:J

    invoke-static {v3, v4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    aput-object v3, v1, v2

    const/4 v2, 0x3

    iget-object v3, p0, Lcom/ta/utdid2/device/a;->b:Ljava/lang/String;

    aput-object v3, v1, v2

    const/4 v2, 0x4

    iget-object v3, p0, Lcom/ta/utdid2/device/a;->a:Ljava/lang/String;

    aput-object v3, v1, v2

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    new-instance v1, Ljava/util/zip/Adler32;

    invoke-direct {v1}, Ljava/util/zip/Adler32;-><init>()V

    invoke-virtual {v1}, Ljava/util/zip/Adler32;->reset()V

    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/util/zip/Adler32;->update([B)V

    invoke-virtual {v1}, Ljava/util/zip/Adler32;->getValue()J

    move-result-wide v0

    :goto_0
    return-wide v0

    :cond_0
    const-wide/16 v0, 0x0

    goto :goto_0
.end method

.method public static a(Landroid/content/Context;)Lcom/ta/utdid2/device/c;
    .locals 2

    if-eqz p0, :cond_1

    sget-object v0, Lcom/ta/utdid2/device/c;->f:Lcom/ta/utdid2/device/c;

    if-nez v0, :cond_1

    sget-object v1, Lcom/ta/utdid2/device/c;->e:Ljava/lang/Object;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcom/ta/utdid2/device/c;->f:Lcom/ta/utdid2/device/c;

    if-nez v0, :cond_0

    new-instance v0, Lcom/ta/utdid2/device/c;

    invoke-direct {v0, p0}, Lcom/ta/utdid2/device/c;-><init>(Landroid/content/Context;)V

    sput-object v0, Lcom/ta/utdid2/device/c;->f:Lcom/ta/utdid2/device/c;

    :cond_0
    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_1
    sget-object v0, Lcom/ta/utdid2/device/c;->f:Lcom/ta/utdid2/device/c;

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method private static a([B)Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const-string v0, "d6fc3a4a06adbde89223bvefedc24fecde188aaa9161"

    const-string v1, "HmacSHA1"

    invoke-static {v1}, Ljavax/crypto/Mac;->getInstance(Ljava/lang/String;)Ljavax/crypto/Mac;

    move-result-object v1

    new-instance v2, Ljavax/crypto/spec/SecretKeySpec;

    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v0

    invoke-virtual {v1}, Ljavax/crypto/Mac;->getAlgorithm()Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v0, v3}, Ljavax/crypto/spec/SecretKeySpec;-><init>([BLjava/lang/String;)V

    invoke-virtual {v1, v2}, Ljavax/crypto/Mac;->init(Ljava/security/Key;)V

    invoke-virtual {v1, p0}, Ljavax/crypto/Mac;->doFinal([B)[B

    move-result-object v0

    const/4 v1, 0x2

    invoke-static {v0, v1}, Lcom/ta/utdid2/android/utils/b;->a([BI)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private a(Ljava/lang/String;)V
    .locals 8

    const/4 v6, 0x0

    invoke-direct {p0, p1}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5

    const-string v0, "\n"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    invoke-virtual {p1, v6, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    :cond_0
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    const/16 v1, 0x18

    if-ne v0, v1, :cond_5

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v1, "UTDID"

    invoke-virtual {v0, v1}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v1, "EI"

    invoke-virtual {v0, v1}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/e;->a(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    iget-object v1, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v2, "SI"

    invoke-virtual {v1, v2}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_2

    iget-object v1, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-static {v1}, Lcom/ta/utdid2/android/utils/e;->b(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    :cond_2
    iget-object v2, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v4, "DID"

    invoke-virtual {v2, v4}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_3

    move-object v2, v0

    :cond_3
    if-eqz v3, :cond_4

    invoke-virtual {v3, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_5

    :cond_4
    new-instance v3, Lcom/ta/utdid2/device/a;

    invoke-direct {v3}, Lcom/ta/utdid2/device/a;-><init>()V

    iput-object v0, v3, Lcom/ta/utdid2/device/a;->a:Ljava/lang/String;

    iput-object v1, v3, Lcom/ta/utdid2/device/a;->b:Ljava/lang/String;

    iput-object p1, v3, Lcom/ta/utdid2/device/a;->d:Ljava/lang/String;

    iput-object v2, v3, Lcom/ta/utdid2/device/a;->c:Ljava/lang/String;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    iput-wide v0, v3, Lcom/ta/utdid2/device/a;->e:J

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v1, "UTDID"

    invoke-virtual {v0, v1, p1}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v1, "EI"

    iget-object v2, v3, Lcom/ta/utdid2/device/a;->a:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v1, "SI"

    iget-object v2, v3, Lcom/ta/utdid2/device/a;->b:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v1, "DID"

    iget-object v2, v3, Lcom/ta/utdid2/device/a;->c:Ljava/lang/String;

    invoke-virtual {v0, v1, v2}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v1, "timestamp"

    iget-wide v4, v3, Lcom/ta/utdid2/device/a;->e:J

    invoke-virtual {v0, v1, v4, v5}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;J)V

    iget-object v2, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v4, "S"

    const-string v0, "%s%s%s%s%s"

    const/4 v1, 0x5

    new-array v1, v1, [Ljava/lang/Object;

    iget-object v5, v3, Lcom/ta/utdid2/device/a;->d:Ljava/lang/String;

    aput-object v5, v1, v6

    const/4 v5, 0x1

    iget-object v6, v3, Lcom/ta/utdid2/device/a;->c:Ljava/lang/String;

    aput-object v6, v1, v5

    const/4 v5, 0x2

    iget-wide v6, v3, Lcom/ta/utdid2/device/a;->e:J

    invoke-static {v6, v7}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v6

    aput-object v6, v1, v5

    const/4 v5, 0x3

    iget-object v6, v3, Lcom/ta/utdid2/device/a;->b:Ljava/lang/String;

    aput-object v6, v1, v5

    const/4 v5, 0x4

    iget-object v3, v3, Lcom/ta/utdid2/device/a;->a:Ljava/lang/String;

    aput-object v3, v1, v5

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_6

    new-instance v1, Ljava/util/zip/Adler32;

    invoke-direct {v1}, Ljava/util/zip/Adler32;-><init>()V

    invoke-virtual {v1}, Ljava/util/zip/Adler32;->reset()V

    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/util/zip/Adler32;->update([B)V

    invoke-virtual {v1}, Ljava/util/zip/Adler32;->getValue()J

    move-result-wide v0

    :goto_0
    invoke-virtual {v2, v4, v0, v1}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;J)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    invoke-virtual {v0}, Lcom/ta/utdid2/core/persistent/c;->a()Z

    :cond_5
    return-void

    :cond_6
    const-wide/16 v0, 0x0

    goto :goto_0
.end method

.method private b()Ljava/lang/String;
    .locals 2

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v1, "UTDID"

    invoke-virtual {v0, v1}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    iget-object v1, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    invoke-virtual {v1, v0}, Lcom/ta/utdid2/device/d;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    :goto_0
    return-object v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method private b(Ljava/lang/String;)V
    .locals 2

    if-eqz p1, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->k:Lcom/ta/utdid2/core/persistent/c;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->k:Lcom/ta/utdid2/core/persistent/c;

    iget-object v1, p0, Lcom/ta/utdid2/device/c;->i:Ljava/lang/String;

    invoke-virtual {v0, v1}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->k:Lcom/ta/utdid2/core/persistent/c;

    iget-object v1, p0, Lcom/ta/utdid2/device/c;->i:Ljava/lang/String;

    invoke-virtual {v0, v1, p1}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->k:Lcom/ta/utdid2/core/persistent/c;

    invoke-virtual {v0}, Lcom/ta/utdid2/core/persistent/c;->a()Z

    :cond_0
    return-void
.end method

.method private c(Ljava/lang/String;)V
    .locals 2

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    const-string v1, "android.permission.WRITE_SETTINGS"

    invoke-virtual {v0, v1}, Landroid/content/Context;->checkCallingOrSelfPermission(Ljava/lang/String;)I

    move-result v0

    if-nez v0, :cond_1

    invoke-direct {p0, p1}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "\n"

    invoke-virtual {p1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    invoke-virtual {p1, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    :cond_0
    const/16 v0, 0x18

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    if-ne v0, v1, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "mqBRboGZkQPcAkyk"

    invoke-static {v0, v1}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "mqBRboGZkQPcAkyk"

    invoke-static {v0, v1, p1}, Landroid/provider/Settings$System;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z

    :cond_1
    return-void
.end method

.method private final c()[B
    .locals 8
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    const/4 v7, 0x4

    const/4 v6, 0x0

    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    const-wide/16 v4, 0x3e8

    div-long/2addr v2, v4

    long-to-int v0, v2

    new-instance v2, Ljava/util/Random;

    invoke-direct {v2}, Ljava/util/Random;-><init>()V

    invoke-virtual {v2}, Ljava/util/Random;->nextInt()I

    move-result v2

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/c;->a(I)[B

    move-result-object v0

    invoke-static {v2}, Lcom/ta/utdid2/android/utils/c;->a(I)[B

    move-result-object v2

    invoke-virtual {v1, v0, v6, v7}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    invoke-virtual {v1, v2, v6, v7}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    const/4 v0, 0x3

    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    :try_start_0
    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/e;->a(Landroid/content/Context;)Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    :goto_0
    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->b(Ljava/lang/String;)I

    move-result v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/c;->a(I)[B

    move-result-object v0

    invoke-virtual {v1, v0, v6, v7}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    const-string v2, "d6fc3a4a06adbde89223bvefedc24fecde188aaa9161"

    const-string v3, "HmacSHA1"

    invoke-static {v3}, Ljavax/crypto/Mac;->getInstance(Ljava/lang/String;)Ljavax/crypto/Mac;

    move-result-object v3

    new-instance v4, Ljavax/crypto/spec/SecretKeySpec;

    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    invoke-virtual {v3}, Ljavax/crypto/Mac;->getAlgorithm()Ljava/lang/String;

    move-result-object v5

    invoke-direct {v4, v2, v5}, Ljavax/crypto/spec/SecretKeySpec;-><init>([BLjava/lang/String;)V

    invoke-virtual {v3, v4}, Ljavax/crypto/Mac;->init(Ljava/security/Key;)V

    invoke-virtual {v3, v0}, Ljavax/crypto/Mac;->doFinal([B)[B

    move-result-object v0

    const/4 v2, 0x2

    invoke-static {v0, v2}, Lcom/ta/utdid2/android/utils/b;->a([BI)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->b(Ljava/lang/String;)I

    move-result v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/c;->a(I)[B

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write([B)V

    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    return-object v0

    :catch_0
    move-exception v0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    new-instance v2, Ljava/util/Random;

    invoke-direct {v2}, Ljava/util/Random;-><init>()V

    invoke-virtual {v2}, Ljava/util/Random;->nextInt()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_0
.end method

.method private d(Ljava/lang/String;)V
    .locals 2

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "dxCRMxhQkdGePGnp"

    invoke-static {v0, v1}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "dxCRMxhQkdGePGnp"

    invoke-static {v0, v1, p1}, Landroid/provider/Settings$System;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z

    :cond_0
    return-void
.end method

.method private e(Ljava/lang/String;)V
    .locals 2

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    const-string v1, "android.permission.WRITE_SETTINGS"

    invoke-virtual {v0, v1}, Landroid/content/Context;->checkCallingOrSelfPermission(Ljava/lang/String;)I

    move-result v0

    if-nez v0, :cond_0

    if-eqz p1, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "dxCRMxhQkdGePGnp"

    invoke-static {v0, v1}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v1, "dxCRMxhQkdGePGnp"

    invoke-static {v0, v1, p1}, Landroid/provider/Settings$System;->putString(Landroid/content/ContentResolver;Ljava/lang/String;Ljava/lang/String;)Z

    :cond_0
    return-void
.end method

.method private f(Ljava/lang/String;)Z
    .locals 3

    const/4 v0, 0x0

    if-eqz p1, :cond_1

    const-string v1, "\n"

    invoke-virtual {p1, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    invoke-virtual {p1, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    :cond_0
    const/16 v1, 0x18

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    if-ne v1, v2, :cond_1

    iget-object v1, p0, Lcom/ta/utdid2/device/c;->q:Ljava/util/regex/Pattern;

    invoke-virtual {v1, p1}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v1

    invoke-virtual {v1}, Ljava/util/regex/Matcher;->find()Z

    move-result v1

    if-nez v1, :cond_1

    const/4 v0, 0x1

    :cond_1
    return v0
.end method


# virtual methods
.method public final declared-synchronized a()Ljava/lang/String;
    .locals 6

    const/4 v1, 0x0

    monitor-enter p0

    :try_start_0
    iget-object v0, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :cond_0
    :goto_0
    monitor-exit p0

    return-object v0

    :cond_1
    :try_start_1
    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v2, "mqBRboGZkQPcAkyk"

    invoke-static {v0, v2}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    new-instance v4, Lcom/ta/utdid2/device/e;

    invoke-direct {v4}, Lcom/ta/utdid2/device/e;-><init>()V

    const/4 v2, 0x0

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v3, "dxCRMxhQkdGePGnp"

    invoke-static {v0, v3}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_3

    invoke-virtual {v4, v3}, Lcom/ta/utdid2/device/e;->b(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_2

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->c(Ljava/lang/String;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception v0

    monitor-exit p0

    throw v0

    :cond_2
    :try_start_2
    invoke-virtual {v4, v3}, Lcom/ta/utdid2/device/e;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_e

    iget-object v5, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    invoke-virtual {v5, v0}, Lcom/ta/utdid2/device/d;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v5

    if-nez v5, :cond_e

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->e(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->d:Landroid/content/Context;

    invoke-virtual {v0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    const-string v3, "dxCRMxhQkdGePGnp"

    invoke-static {v0, v3}, Landroid/provider/Settings$System;->getString(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_1
    iget-object v3, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    invoke-virtual {v3, v0}, Lcom/ta/utdid2/device/d;->b(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {p0, v3}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_4

    iput-object v3, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    invoke-direct {p0, v3}, Lcom/ta/utdid2/device/c;->a(Ljava/lang/String;)V

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->b(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->c(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    goto :goto_0

    :cond_3
    const/4 v0, 0x1

    move v2, v0

    :cond_4
    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    if-eqz v0, :cond_6

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->n:Lcom/ta/utdid2/core/persistent/c;

    const-string v3, "UTDID"

    invoke-virtual {v0, v3}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_6

    iget-object v3, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    invoke-virtual {v3, v0}, Lcom/ta/utdid2/device/d;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_6

    :goto_2
    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_7

    iget-object v1, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    invoke-virtual {v1, v0}, Lcom/ta/utdid2/device/d;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v2, :cond_5

    invoke-direct {p0, v1}, Lcom/ta/utdid2/device/c;->e(Ljava/lang/String;)V

    :cond_5
    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->c(Ljava/lang/String;)V

    invoke-direct {p0, v1}, Lcom/ta/utdid2/device/c;->b(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    goto/16 :goto_0

    :cond_6
    move-object v0, v1

    goto :goto_2

    :cond_7
    iget-object v0, p0, Lcom/ta/utdid2/device/c;->k:Lcom/ta/utdid2/core/persistent/c;

    iget-object v3, p0, Lcom/ta/utdid2/device/c;->i:Ljava/lang/String;

    invoke-virtual {v0, v3}, Lcom/ta/utdid2/core/persistent/c;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_a

    invoke-virtual {v4, v3}, Lcom/ta/utdid2/device/e;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_8

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    invoke-virtual {v0, v3}, Lcom/ta/utdid2/device/d;->b(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_8
    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->f(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_a

    iget-object v3, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    invoke-virtual {v3, v0}, Lcom/ta/utdid2/device/d;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v0}, Lcom/ta/utdid2/android/utils/f;->a(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_a

    iput-object v0, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    if-eqz v2, :cond_9

    invoke-direct {p0, v3}, Lcom/ta/utdid2/device/c;->e(Ljava/lang/String;)V

    :cond_9
    iget-object v0, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->a(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto/16 :goto_0

    :cond_a
    :try_start_3
    invoke-direct {p0}, Lcom/ta/utdid2/device/c;->c()[B

    move-result-object v0

    if-eqz v0, :cond_d

    const/4 v3, 0x2

    invoke-static {v0, v3}, Lcom/ta/utdid2/android/utils/b;->a([BI)Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    iget-object v3, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;

    invoke-direct {p0, v3}, Lcom/ta/utdid2/device/c;->a(Ljava/lang/String;)V

    iget-object v3, p0, Lcom/ta/utdid2/device/c;->h:Lcom/ta/utdid2/device/d;

    invoke-virtual {v3, v0}, Lcom/ta/utdid2/device/d;->a([B)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_c

    if-eqz v2, :cond_b

    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->e(Ljava/lang/String;)V

    :cond_b
    invoke-direct {p0, v0}, Lcom/ta/utdid2/device/c;->b(Ljava/lang/String;)V

    :cond_c
    iget-object v0, p0, Lcom/ta/utdid2/device/c;->g:Ljava/lang/String;
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto/16 :goto_0

    :catch_0
    move-exception v0

    :try_start_4
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    :cond_d
    move-object v0, v1

    goto/16 :goto_0

    :cond_e
    move-object v0, v3

    goto/16 :goto_1
.end method
