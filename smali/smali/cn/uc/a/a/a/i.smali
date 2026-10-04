.class public final Lcn/uc/a/a/a/i;
.super Ljava/lang/Object;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcn/uc/a/a/a/i$4;,
        Lcn/uc/a/a/a/i$a;
    }
.end annotation


# static fields
.field private static a:Lcn/uc/a/a/a/j; = null

.field private static final b:Ljava/lang/String; = "UCLog"

.field private static final c:Ljava/lang/String; = "UCGameSdk"


# direct methods
.method static constructor <clinit>()V
    .locals 1

    sget-object v0, Lcn/uc/a/a/a/j;->c:Lcn/uc/a/a/a/j;

    sput-object v0, Lcn/uc/a/a/a/i;->a:Lcn/uc/a/a/a/j;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a(Ljava/lang/String;I)Lcn/uc/a/a/a/a/j;
    .locals 1

    const/4 v0, 0x1

    invoke-static {p0, p1, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;II)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    return-object v0
.end method

.method public static a(Ljava/lang/String;II)Lcn/uc/a/a/a/a/j;
    .locals 4

    new-instance v0, Lcn/uc/a/a/a/a/n;

    invoke-direct {v0}, Lcn/uc/a/a/a/a/n;-><init>()V

    invoke-virtual {v0, p0}, Lcn/uc/a/a/a/a/n;->a(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Lcn/uc/a/a/a/a/n;->a(I)V

    invoke-virtual {v0, p2}, Lcn/uc/a/a/a/a/n;->b(I)V

    invoke-static {}, Lcn/uc/a/a/a/a/k;->b()Ljava/lang/String;

    move-result-object v1

    const-string v2, "system.sdklog"

    const-string v3, "key_mve"

    invoke-static {v3}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v2, v0, v3}, Lcn/uc/a/a/a/a/g;->a(Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/a/c;Ljava/lang/String;)Lcn/uc/a/a/a/a/j;

    move-result-object v0

    return-object v0
.end method

.method private static a(Ljava/lang/Exception;)Ljava/lang/String;
    .locals 2

    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    new-instance v1, Ljava/io/PrintStream;

    invoke-direct {v1, v0}, Ljava/io/PrintStream;-><init>(Ljava/io/OutputStream;)V

    invoke-virtual {p0, v1}, Ljava/lang/Exception;->printStackTrace(Ljava/io/PrintStream;)V

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static a()V
    .locals 4

    const-string v0, ""

    const-string v1, "K"

    const-wide/16 v2, 0x0

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;J)V

    return-void
.end method

.method private static a(Lcn/uc/a/a/a/e;Ljava/lang/String;)V
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/i$4;->a:[I

    invoke-virtual {p0}, Lcn/uc/a/a/a/e;->ordinal()I

    move-result v1

    aget v0, v0, v1

    packed-switch v0, :pswitch_data_0

    :goto_0
    return-void

    :pswitch_0
    const-string v0, "UCGameSdk"

    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :pswitch_1
    const-string v0, "UCGameSdk"

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :pswitch_2
    const-string v0, "UCGameSdk"

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :pswitch_3
    const-string v0, "UCGameSdk"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_3
        :pswitch_3
        :pswitch_3
    .end packed-switch
.end method

.method private static a(Lcn/uc/a/a/a/e;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V
    .locals 3

    if-eqz p4, :cond_0

    invoke-static {p3}, Lcn/uc/a/a/a/b/j;->k(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_3

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\r\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {p4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/Exception;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    :cond_0
    :goto_0
    if-nez p1, :cond_1

    const-string p1, ""

    :cond_1
    if-nez p2, :cond_2

    const-string p2, ""

    :cond_2
    const-string v0, "%s`%s`%s"

    const/4 v1, 0x3

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p1, v1, v2

    const/4 v2, 0x1

    aput-object p2, v1, v2

    const/4 v2, 0x2

    aput-object p3, v1, v2

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, p0}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;Lcn/uc/a/a/a/e;)V

    invoke-static {p0, v0}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;)V

    return-void

    :cond_3
    invoke-static {p4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/Exception;)Ljava/lang/String;

    move-result-object p3

    goto :goto_0
.end method

.method public static a(Lcn/uc/a/a/a/j;)V
    .locals 0

    sput-object p0, Lcn/uc/a/a/a/i;->a:Lcn/uc/a/a/a/j;

    return-void
.end method

.method public static a(Ljava/lang/String;)V
    .locals 0

    invoke-static {p0}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;)V

    return-void
.end method

.method private static declared-synchronized a(Ljava/lang/String;Ljava/lang/String;J)V
    .locals 8

    const-class v2, Lcn/uc/a/a/a/i;

    monitor-enter v2

    :try_start_0
    sget-object v0, Lcn/uc/a/a/a/a;->n:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_0
    :goto_0
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_3

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map$Entry;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    invoke-interface {v0}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    const-wide/16 v6, 0x0

    cmp-long v0, v4, v6

    if-lez v0, :cond_0

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_1

    invoke-virtual {v1, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_2

    :cond_1
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_0

    :cond_2
    const-string v0, ""

    invoke-static {v1, p1, v0, p2, p3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V

    invoke-static {v1}, Lcn/uc/a/a/a/f;->d(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catch_0
    move-exception v0

    :try_start_1
    const-string v1, "UCLog"

    const-string v3, "dumpStatLogs"

    const-string v4, ""

    invoke-static {v1, v3, v4, v0}, Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :cond_3
    monitor-exit v2

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v2

    throw v0
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x0

    invoke-static {p0, p1, p2, v0}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V

    return-void
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V
    .locals 6

    const/4 v3, 0x0

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-wide v4, p3

    invoke-static/range {v0 .. v5}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJ)V

    return-void
.end method

.method private static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JLcn/uc/a/a/a/i$a;)V
    .locals 6

    const-string v0, "enter"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    invoke-static {p0, v0, v1}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;J)V

    :cond_0
    :goto_0
    return-void

    :cond_1
    invoke-static {p0}, Lcn/uc/a/a/a/f;->b(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "key_ucid"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v0

    const-string v1, "%s`%s`%d`%d`%d`%s"

    const/4 v2, 0x6

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object p0, v2, v3

    const/4 v3, 0x1

    aput-object p1, v2, v3

    const/4 v3, 0x2

    invoke-static {p0}, Lcn/uc/a/a/a/f;->c(Ljava/lang/String;)J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    const/4 v3, 0x3

    invoke-static {p3, p4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    const/4 v3, 0x4

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v2, v3

    const/4 v0, 0x5

    aput-object p2, v2, v0

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/f;->b(Ljava/lang/String;Lcn/uc/a/a/a/e;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/Thread;

    new-instance v3, Lcn/uc/a/a/a/i$2;

    invoke-direct {v3, v1, p5, v0}, Lcn/uc/a/a/a/i$2;-><init>(Ljava/lang/String;Lcn/uc/a/a/a/i$a;Ljava/lang/String;)V

    invoke-direct {v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v2}, Ljava/lang/Thread;->start()V

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v1, v0}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcn/uc/a/a/a/i$a;)V
    .locals 6

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v3

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move-object v5, p3

    invoke-static/range {v0 .. v5}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JLcn/uc/a/a/a/i$a;)V

    return-void
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/i;->a:Lcn/uc/a/a/a/j;

    invoke-virtual {v0}, Lcn/uc/a/a/a/j;->ordinal()I

    move-result v0

    sget-object v1, Lcn/uc/a/a/a/j;->c:Lcn/uc/a/a/a/j;

    invoke-virtual {v1}, Lcn/uc/a/a/a/j;->ordinal()I

    move-result v1

    if-ge v0, v1, :cond_0

    :goto_0
    return-void

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/e;->c:Lcn/uc/a/a/a/e;

    invoke-static {v0, p0, p1, p2, p3}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V

    goto :goto_0
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "cost-"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "."

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, p2, p3}, Lcn/uc/a/a/a/i;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/i;->a:Lcn/uc/a/a/a/j;

    invoke-virtual {v0}, Lcn/uc/a/a/a/j;->ordinal()I

    move-result v0

    sget-object v1, Lcn/uc/a/a/a/j;->a:Lcn/uc/a/a/a/j;

    invoke-virtual {v1}, Lcn/uc/a/a/a/j;->ordinal()I

    move-result v1

    if-ge v0, v1, :cond_0

    :goto_0
    return-void

    :cond_0
    invoke-static/range {p0 .. p6}, Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V

    goto :goto_0
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V
    .locals 6

    const-string v0, "msg:%s"

    const/4 v1, 0x1

    new-array v1, v1, [Ljava/lang/Object;

    const/4 v2, 0x0

    aput-object p2, v1, v2

    invoke-static {v0, v1}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    move-object v0, p0

    move-object v1, p1

    move v3, p3

    invoke-static/range {v0 .. v5}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJ)V

    return-void
.end method

.method public static a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJ)V
    .locals 6

    const-string v0, "enter"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    invoke-static {p0, v0, v1}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;J)V

    :cond_0
    :goto_0
    return-void

    :cond_1
    invoke-static {p0}, Lcn/uc/a/a/a/f;->b(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "key_ucid"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v0

    const-string v1, "%s`%s`%d`%d`%d`%s"

    const/4 v2, 0x6

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object p0, v2, v3

    const/4 v3, 0x1

    aput-object p1, v2, v3

    const/4 v3, 0x2

    invoke-static {p0}, Lcn/uc/a/a/a/f;->c(Ljava/lang/String;)J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    const/4 v3, 0x3

    invoke-static {p4, p5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    const/4 v3, 0x4

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v2, v3

    const/4 v0, 0x5

    aput-object p2, v2, v0

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    if-eqz p3, :cond_2

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/f;->b(Ljava/lang/String;Lcn/uc/a/a/a/e;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/Thread;

    new-instance v3, Lcn/uc/a/a/a/i$3;

    invoke-direct {v3, v1, v0}, Lcn/uc/a/a/a/i$3;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v2}, Ljava/lang/Thread;->start()V

    :goto_1
    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v1, v0}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;)V

    invoke-static {p0}, Lcn/uc/a/a/a/f;->d(Ljava/lang/String;)V

    goto :goto_0

    :cond_2
    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;Lcn/uc/a/a/a/e;)V

    goto :goto_1
.end method

.method public static b()V
    .locals 4

    const-string v0, "page."

    const-string v1, "close"

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;J)V

    return-void
.end method

.method public static b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/e;->f:Lcn/uc/a/a/a/e;

    const/4 v1, 0x0

    invoke-static {v0, p0, p1, p2, v1}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V

    return-void
.end method

.method public static b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/i;->a:Lcn/uc/a/a/a/j;

    invoke-virtual {v0}, Lcn/uc/a/a/a/j;->ordinal()I

    move-result v0

    sget-object v1, Lcn/uc/a/a/a/j;->b:Lcn/uc/a/a/a/j;

    invoke-virtual {v1}, Lcn/uc/a/a/a/j;->ordinal()I

    move-result v1

    if-ge v0, v1, :cond_0

    :goto_0
    return-void

    :cond_0
    sget-object v0, Lcn/uc/a/a/a/e;->b:Lcn/uc/a/a/a/e;

    invoke-static {v0, p0, p1, p2, p3}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V

    goto :goto_0
.end method

.method private static b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;ILjava/lang/String;)V
    .locals 6

    if-eqz p4, :cond_0

    invoke-static {p3}, Lcn/uc/a/a/a/b/j;->k(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_6

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\r\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {p4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/Exception;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    :cond_0
    :goto_0
    const-string v0, "key_ucid"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v1

    invoke-static {}, Lcn/uc/a/a/a/b/a;->a()Ljava/lang/String;

    move-result-object v0

    if-nez p0, :cond_1

    const-string p0, ""

    :cond_1
    if-nez p1, :cond_2

    const-string p1, ""

    :cond_2
    if-nez p2, :cond_3

    const-string p2, ""

    :cond_3
    if-nez v0, :cond_4

    const-string v0, ""

    :cond_4
    if-nez p3, :cond_5

    const-string p3, ""

    :cond_5
    const-string v2, "%s`%s`%d`%d`%s`%s`%s`%s"

    const/16 v3, 0x8

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    aput-object p0, v3, v4

    const/4 v4, 0x1

    aput-object p1, v3, v4

    const/4 v4, 0x2

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    aput-object v1, v3, v4

    const/4 v1, 0x3

    invoke-static {p5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v3, v1

    const/4 v1, 0x4

    aput-object p2, v3, v1

    const/4 v1, 0x5

    aput-object v0, v3, v1

    const/4 v0, 0x6

    const-string v1, "\n"

    const-string v4, "<br>"

    invoke-virtual {p3, v1, v4}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    const-string v4, "\r"

    const-string v5, ""

    invoke-virtual {v1, v4, v5}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    aput-object v1, v3, v0

    const/4 v0, 0x7

    aput-object p6, v3, v0

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcn/uc/a/a/a/e;->a:Lcn/uc/a/a/a/e;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;Lcn/uc/a/a/a/e;)V

    sget-object v0, Lcn/uc/a/a/a/e;->a:Lcn/uc/a/a/a/e;

    invoke-static {v0, p3}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;)V

    return-void

    :cond_6
    invoke-static {p4}, Lcn/uc/a/a/a/i;->a(Ljava/lang/Exception;)Ljava/lang/String;

    move-result-object p3

    goto :goto_0
.end method

.method public static b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V
    .locals 6

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    move-object v0, p0

    move-object v1, p1

    move-object v2, p2

    move v3, p3

    invoke-static/range {v0 .. v5}, Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJ)V

    return-void
.end method

.method private static b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZJ)V
    .locals 6

    const-string v0, "enter"

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    invoke-static {p0, v0, v1}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;J)V

    :cond_0
    :goto_0
    return-void

    :cond_1
    invoke-static {p0}, Lcn/uc/a/a/a/f;->b(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "key_ucid"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v0

    const-string v1, "%s`%s`%d`%d`%d`%s"

    const/4 v2, 0x6

    new-array v2, v2, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object p0, v2, v3

    const/4 v3, 0x1

    aput-object p1, v2, v3

    const/4 v3, 0x2

    invoke-static {p0}, Lcn/uc/a/a/a/f;->c(Ljava/lang/String;)J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    const/4 v3, 0x3

    invoke-static {p4, p5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    const/4 v3, 0x4

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v2, v3

    const/4 v0, 0x5

    aput-object p2, v2, v0

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    if-eqz p3, :cond_2

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/f;->b(Ljava/lang/String;Lcn/uc/a/a/a/e;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/Thread;

    new-instance v3, Lcn/uc/a/a/a/i$1;

    invoke-direct {v3, v1, v0}, Lcn/uc/a/a/a/i$1;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v2}, Ljava/lang/Thread;->start()V

    :goto_1
    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v1, v0}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;)V

    goto :goto_0

    :cond_2
    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;Lcn/uc/a/a/a/e;)V

    goto :goto_1
.end method

.method public static c()V
    .locals 4

    const-string v0, "cost-"

    const-string v1, "cost"

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    invoke-static {v0, v1, v2, v3}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;J)V

    return-void
.end method

.method public static c(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1

    const/4 v0, 0x0

    invoke-static {p0, p1, p2, v0}, Lcn/uc/a/a/a/i;->b(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V

    return-void
.end method

.method public static d(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/e;->d:Lcn/uc/a/a/a/e;

    const/4 v1, 0x0

    invoke-static {v0, p0, p1, p2, v1}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Exception;)V

    return-void
.end method

.method public static e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    invoke-static {p0, p1, p2, v0, v1}, Lcn/uc/a/a/a/i;->a(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V

    return-void
.end method

.method public static f(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 6

    const/4 v5, 0x0

    const-string v0, "key_ucid"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v0

    const-string v1, "%s`%s`%d`%d`%d`%s"

    const/4 v2, 0x6

    new-array v2, v2, [Ljava/lang/Object;

    aput-object p0, v2, v5

    const/4 v3, 0x1

    aput-object p1, v2, v3

    const/4 v3, 0x2

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v3

    const/4 v3, 0x3

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v3

    const/4 v3, 0x4

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v2, v3

    const/4 v0, 0x5

    aput-object p2, v2, v0

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v0, v1}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;Lcn/uc/a/a/a/e;)V

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-static {v1, v0}, Lcn/uc/a/a/a/i;->a(Lcn/uc/a/a/a/e;Ljava/lang/String;)V

    return-void
.end method
