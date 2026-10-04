.class public Lcn/uc/a/a/a/f;
.super Ljava/lang/Object;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcn/uc/a/a/a/f$1;
    }
.end annotation


# static fields
.field private static final a:Ljava/lang/String; = "ucgamesdk/config/statcost_filter.ini"

.field private static final b:Ljava/lang/String; = "conf/statcost_filter.ini"

.field private static final c:Ljava/lang/String; = "%s/ucgamesdk/%d/logs/errlog"

.field private static final d:Ljava/lang/String; = "%s/ucgamesdk/%d/logs/warnlog"

.field private static final e:Ljava/lang/String; = "%s/ucgamesdk/%d/logs/debuglog"

.field private static final f:Ljava/lang/String; = "%s/ucgamesdk/%d/logs/actionlog"

.field private static final g:Ljava/lang/String; = "%s/ucgamesdk/%d/logs/updatelog"

.field private static final h:Ljava/lang/String; = "%s/ucgamesdk/%d/logs/statlog"

.field private static final i:Ljava/lang/String; = "%s/errlog"

.field private static final j:Ljava/lang/String; = "%s/updatelog"

.field private static final k:Ljava/lang/String; = "%s/statlog"

.field private static final l:Ljava/lang/String; = "Logger"

.field private static m:Z

.field private static n:Z

.field private static o:Ljava/lang/String;

.field private static p:Z

.field private static q:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Lcn/uc/a/a/a/c;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 7

    const/16 v6, 0x1e

    const/4 v5, 0x1

    const/4 v4, 0x0

    sput-boolean v4, Lcn/uc/a/a/a/f;->m:Z

    sput-boolean v4, Lcn/uc/a/a/a/f;->n:Z

    const-string v0, "test"

    sput-object v0, Lcn/uc/a/a/a/f;->o:Ljava/lang/String;

    sput-boolean v4, Lcn/uc/a/a/a/f;->p:Z

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lcn/uc/a/a/a/f;->q:Ljava/util/ArrayList;

    sget-object v0, Lcn/uc/a/a/a/f;->q:Ljava/util/ArrayList;

    new-instance v1, Lcn/uc/a/a/a/c;

    sget-object v2, Lcn/uc/a/a/a/e;->c:Lcn/uc/a/a/a/e;

    const/4 v3, 0x7

    invoke-direct {v1, v2, v3, v4}, Lcn/uc/a/a/a/c;-><init>(Lcn/uc/a/a/a/e;IZ)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    sget-object v0, Lcn/uc/a/a/a/f;->q:Ljava/util/ArrayList;

    new-instance v1, Lcn/uc/a/a/a/c;

    sget-object v2, Lcn/uc/a/a/a/e;->b:Lcn/uc/a/a/a/e;

    const/16 v3, 0xf

    invoke-direct {v1, v2, v3, v4}, Lcn/uc/a/a/a/c;-><init>(Lcn/uc/a/a/a/e;IZ)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    sget-object v0, Lcn/uc/a/a/a/f;->q:Ljava/util/ArrayList;

    new-instance v1, Lcn/uc/a/a/a/c;

    sget-object v2, Lcn/uc/a/a/a/e;->a:Lcn/uc/a/a/a/e;

    invoke-direct {v1, v2, v6, v5}, Lcn/uc/a/a/a/c;-><init>(Lcn/uc/a/a/a/e;IZ)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    sget-object v0, Lcn/uc/a/a/a/f;->q:Ljava/util/ArrayList;

    new-instance v1, Lcn/uc/a/a/a/c;

    sget-object v2, Lcn/uc/a/a/a/e;->d:Lcn/uc/a/a/a/e;

    invoke-direct {v1, v2, v6, v5}, Lcn/uc/a/a/a/c;-><init>(Lcn/uc/a/a/a/e;IZ)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    sget-object v0, Lcn/uc/a/a/a/f;->q:Ljava/util/ArrayList;

    new-instance v1, Lcn/uc/a/a/a/c;

    sget-object v2, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    invoke-direct {v1, v2, v6, v5}, Lcn/uc/a/a/a/c;-><init>(Lcn/uc/a/a/a/e;IZ)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static a()Ljava/io/InputStream;
    .locals 3

    const/4 v0, 0x0

    :try_start_0
    const-string v1, "conf/statcost_filter.ini"

    invoke-static {v1}, Lcn/uc/a/a/a/f;->e(Ljava/lang/String;)Ljava/io/InputStream;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v0

    :goto_0
    return-object v0

    :catch_0
    move-exception v1

    const/4 v2, 0x1

    sput-boolean v2, Lcn/uc/a/a/a/f;->p:Z

    const-string v2, "Logger"

    invoke-virtual {v1}, Ljava/io/IOException;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_0
.end method

.method public static a(Lcn/uc/a/a/a/e;)Ljava/lang/String;
    .locals 8

    const/4 v3, 0x4

    const/4 v7, 0x3

    const/4 v6, 0x2

    const/4 v5, 0x1

    const/4 v4, 0x0

    const-string v0, "yyyyMMddkk"

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->j(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    sget-object v1, Lcn/uc/a/a/a/e;->a:Lcn/uc/a/a/a/e;

    if-eq p0, v1, :cond_0

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    if-ne p0, v1, :cond_1

    :cond_0
    const-string v0, "yyyyMMddkkmm"

    invoke-static {v0}, Lcn/uc/a/a/a/b/j;->j(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :cond_1
    sget-object v1, Lcn/uc/a/a/a/f$1;->a:[I

    invoke-virtual {p0}, Lcn/uc/a/a/a/e;->ordinal()I

    move-result v2

    aget v1, v1, v2

    packed-switch v1, :pswitch_data_0

    const-string v1, "%s_%s.%s.%s"

    new-array v2, v3, [Ljava/lang/Object;

    const-string v3, "unknown"

    aput-object v3, v2, v4

    aput-object v0, v2, v5

    sget-object v0, Lcn/uc/a/a/a/f;->o:Ljava/lang/String;

    aput-object v0, v2, v6

    const-string v0, "log"

    aput-object v0, v2, v7

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    :goto_0
    return-object v0

    :pswitch_0
    const-string v1, "%s_%s.%s.%s"

    new-array v2, v3, [Ljava/lang/Object;

    const-string v3, "debug"

    aput-object v3, v2, v4

    aput-object v0, v2, v5

    sget-object v0, Lcn/uc/a/a/a/f;->o:Ljava/lang/String;

    aput-object v0, v2, v6

    const-string v0, "log"

    aput-object v0, v2, v7

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_1
    const-string v1, "%s_%s.%s.%s"

    new-array v2, v3, [Ljava/lang/Object;

    const-string v3, "warn"

    aput-object v3, v2, v4

    aput-object v0, v2, v5

    sget-object v0, Lcn/uc/a/a/a/f;->o:Ljava/lang/String;

    aput-object v0, v2, v6

    const-string v0, "log"

    aput-object v0, v2, v7

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_2
    const-string v1, "%s_%s.%s.%s"

    new-array v2, v3, [Ljava/lang/Object;

    const-string v3, "error"

    aput-object v3, v2, v4

    aput-object v0, v2, v5

    sget-object v0, Lcn/uc/a/a/a/f;->o:Ljava/lang/String;

    aput-object v0, v2, v6

    const-string v0, "log"

    aput-object v0, v2, v7

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_3
    const-string v1, "%s_%s.%s.%s"

    new-array v2, v3, [Ljava/lang/Object;

    const-string v3, "update"

    aput-object v3, v2, v4

    aput-object v0, v2, v5

    sget-object v0, Lcn/uc/a/a/a/f;->o:Ljava/lang/String;

    aput-object v0, v2, v6

    const-string v0, "log"

    aput-object v0, v2, v7

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_4
    const-string v1, "%s_%s.%s.%s"

    new-array v2, v3, [Ljava/lang/Object;

    const-string v3, "stat"

    aput-object v3, v2, v4

    aput-object v0, v2, v5

    sget-object v0, Lcn/uc/a/a/a/f;->o:Ljava/lang/String;

    aput-object v0, v2, v6

    const-string v0, "log"

    aput-object v0, v2, v7

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_5
    const-string v1, "%s_%s.%s.%s"

    new-array v2, v3, [Ljava/lang/Object;

    const-string v3, "action"

    aput-object v3, v2, v4

    aput-object v0, v2, v5

    sget-object v0, Lcn/uc/a/a/a/f;->o:Ljava/lang/String;

    aput-object v0, v2, v6

    const-string v0, "log"

    aput-object v0, v2, v7

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_0
        :pswitch_5
        :pswitch_1
        :pswitch_2
        :pswitch_3
        :pswitch_4
    .end packed-switch
.end method

.method public static a(Lcn/uc/a/a/a/e;Lcn/uc/a/a/a/h;)Ljava/lang/String;
    .locals 7

    const/4 v6, 0x2

    const/4 v5, 0x1

    const/4 v4, 0x0

    const-string v0, "key_rootDir"

    invoke-static {v0}, Lcn/uc/a/a/a/a;->c(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "key_gameId"

    invoke-static {v1}, Lcn/uc/a/a/a/a;->b(Ljava/lang/String;)I

    move-result v1

    if-eqz v0, :cond_0

    sget-object v2, Lcn/uc/a/a/a/f$1;->a:[I

    invoke-virtual {p0}, Lcn/uc/a/a/a/e;->ordinal()I

    move-result v3

    aget v2, v2, v3

    packed-switch v2, :pswitch_data_0

    const/4 v0, 0x0

    :cond_0
    :goto_0
    return-object v0

    :pswitch_0
    const-string v2, "%s/ucgamesdk/%d/logs/debuglog"

    new-array v3, v6, [Ljava/lang/Object;

    aput-object v0, v3, v4

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v3, v5

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_1
    const-string v2, "%s/ucgamesdk/%d/logs/actionlog"

    new-array v3, v6, [Ljava/lang/Object;

    aput-object v0, v3, v4

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v3, v5

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_2
    const-string v2, "%s/ucgamesdk/%d/logs/warnlog"

    new-array v3, v6, [Ljava/lang/Object;

    aput-object v0, v3, v4

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v3, v5

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_3
    sget-object v2, Lcn/uc/a/a/a/h;->b:Lcn/uc/a/a/a/h;

    if-ne p1, v2, :cond_1

    const-string v2, "%s/ucgamesdk/%d/logs/errlog"

    new-array v3, v6, [Ljava/lang/Object;

    aput-object v0, v3, v4

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v3, v5

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_1
    const-string v1, "%s/errlog"

    new-array v2, v5, [Ljava/lang/Object;

    aput-object v0, v2, v4

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_4
    sget-object v2, Lcn/uc/a/a/a/h;->b:Lcn/uc/a/a/a/h;

    if-ne p1, v2, :cond_2

    const-string v2, "%s/ucgamesdk/%d/logs/updatelog"

    new-array v3, v6, [Ljava/lang/Object;

    aput-object v0, v3, v4

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v3, v5

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :cond_2
    const-string v1, "%s/updatelog"

    new-array v2, v5, [Ljava/lang/Object;

    aput-object v0, v2, v4

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto :goto_0

    :pswitch_5
    sget-object v2, Lcn/uc/a/a/a/h;->b:Lcn/uc/a/a/a/h;

    if-ne p1, v2, :cond_3

    const-string v2, "%s/ucgamesdk/%d/logs/statlog"

    new-array v3, v6, [Ljava/lang/Object;

    aput-object v0, v3, v4

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    aput-object v0, v3, v5

    invoke-static {v2, v3}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0

    :cond_3
    const-string v1, "%s/statlog"

    new-array v2, v5, [Ljava/lang/Object;

    aput-object v0, v2, v4

    invoke-static {v1, v2}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    goto/16 :goto_0

    nop

    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_0
        :pswitch_0
        :pswitch_1
        :pswitch_2
        :pswitch_3
        :pswitch_4
        :pswitch_5
    .end packed-switch
.end method

.method public static a(Ljava/lang/String;)V
    .locals 0

    sput-object p0, Lcn/uc/a/a/a/f;->o:Ljava/lang/String;

    return-void
.end method

.method private static a(Ljava/lang/String;I)V
    .locals 14

    const/4 v13, 0x6

    const/4 v12, 0x4

    const/4 v11, 0x1

    const/4 v2, 0x0

    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v3

    const/4 v0, 0x5

    neg-int v1, p1

    invoke-virtual {v3, v0, v1}, Ljava/util/Calendar;->add(II)V

    invoke-static {}, Ljava/util/Calendar;->getInstance()Ljava/util/Calendar;

    move-result-object v4

    new-instance v0, Ljava/io/File;

    invoke-direct {v0, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-virtual {v0}, Ljava/io/File;->isDirectory()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-virtual {v0}, Ljava/io/File;->canWrite()Z

    move-result v1

    if-eqz v1, :cond_3

    invoke-virtual {v0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v5

    array-length v6, v5

    move v1, v2

    :goto_0
    if-ge v1, v6, :cond_3

    aget-object v7, v5, v1

    if-eqz v7, :cond_2

    invoke-virtual {v7}, Ljava/io/File;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v8, "_"

    invoke-virtual {v0, v8}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v8

    add-int/lit8 v8, v8, 0x1

    add-int/lit8 v9, v8, 0x8

    const/16 v10, 0x7b2

    invoke-virtual {v4, v10, v11, v11}, Ljava/util/Calendar;->set(III)V

    if-lez v8, :cond_1

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v10

    if-gt v9, v10, :cond_1

    invoke-virtual {v0, v8, v9}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v2, v12}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v0, v12, v13}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v9

    const/16 v10, 0x8

    invoke-virtual {v0, v13, v10}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v10

    :try_start_0
    invoke-static {v8}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v8

    invoke-static {v9}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    if-lez v0, :cond_0

    add-int/lit8 v0, v0, -0x1

    :cond_0
    invoke-static {v10}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v9

    invoke-virtual {v4, v8, v0, v9}, Ljava/util/Calendar;->set(III)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :cond_1
    :goto_1
    invoke-virtual {v4, v3}, Ljava/util/Calendar;->before(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual {v7}, Ljava/io/File;->delete()Z

    :cond_2
    add-int/lit8 v0, v1, 0x1

    move v1, v0

    goto :goto_0

    :cond_3
    return-void

    :catch_0
    move-exception v0

    goto :goto_1
.end method

.method public static declared-synchronized a(Ljava/lang/String;J)V
    .locals 3

    const-class v1, Lcn/uc/a/a/a/f;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/a/a/a/a;->n:Ljava/util/HashMap;

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    invoke-virtual {v0, p0, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method public static a(Ljava/lang/String;Lcn/uc/a/a/a/e;)V
    .locals 5

    invoke-static {}, Lcn/uc/a/a/a/f;->b()V

    sget-boolean v0, Lcn/uc/a/a/a/f;->p:Z

    if-eqz v0, :cond_0

    invoke-static {}, Lcn/uc/a/a/a/f;->c()V

    :cond_0
    invoke-static {p1}, Lcn/uc/a/a/a/f;->b(Lcn/uc/a/a/a/e;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    new-instance v1, Ljava/io/File;

    invoke-direct {v1, v0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_1

    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    :cond_1
    invoke-static {p1}, Lcn/uc/a/a/a/f;->a(Lcn/uc/a/a/a/e;)Ljava/lang/String;

    move-result-object v3

    const/4 v2, 0x0

    :try_start_0
    new-instance v1, Ljava/io/RandomAccessFile;

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v4, "/"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v3, "rw"

    invoke-direct {v1, v0, v3}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :try_start_1
    invoke-virtual {v1}, Ljava/io/RandomAccessFile;->length()J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Ljava/io/RandomAccessFile;->seek(J)V

    invoke-static {p0, p1}, Lcn/uc/a/a/a/f;->b(Ljava/lang/String;Lcn/uc/a/a/a/e;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/io/RandomAccessFile;->write([B)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_4
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    if-eqz v1, :cond_2

    :try_start_2
    invoke-virtual {v1}, Ljava/io/RandomAccessFile;->close()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    :cond_2
    :goto_0
    return-void

    :catch_0
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0

    :catch_1
    move-exception v0

    move-object v1, v2

    :goto_1
    :try_start_3
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    if-eqz v1, :cond_2

    :try_start_4
    invoke-virtual {v1}, Ljava/io/RandomAccessFile;->close()V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_2

    goto :goto_0

    :catch_2
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0

    :catchall_0
    move-exception v0

    :goto_2
    if-eqz v2, :cond_3

    :try_start_5
    invoke-virtual {v2}, Ljava/io/RandomAccessFile;->close()V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_3

    :cond_3
    :goto_3
    throw v0

    :catch_3
    move-exception v1

    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_3

    :catchall_1
    move-exception v0

    move-object v2, v1

    goto :goto_2

    :catch_4
    move-exception v0

    goto :goto_1
.end method

.method private static b(Lcn/uc/a/a/a/e;)Ljava/lang/String;
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/h;->b:Lcn/uc/a/a/a/h;

    sget-object v1, Lcn/uc/a/a/a/e;->a:Lcn/uc/a/a/a/e;

    if-eq p0, v1, :cond_0

    sget-object v1, Lcn/uc/a/a/a/e;->d:Lcn/uc/a/a/a/e;

    if-eq p0, v1, :cond_0

    sget-object v1, Lcn/uc/a/a/a/e;->e:Lcn/uc/a/a/a/e;

    if-ne p0, v1, :cond_1

    :cond_0
    invoke-static {}, Lcn/uc/a/a/a/b/h;->c()Z

    move-result v1

    if-nez v1, :cond_1

    sget-object v0, Lcn/uc/a/a/a/h;->a:Lcn/uc/a/a/a/h;

    :cond_1
    invoke-static {p0, v0}, Lcn/uc/a/a/a/f;->a(Lcn/uc/a/a/a/e;Lcn/uc/a/a/a/h;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static b(Ljava/lang/String;Lcn/uc/a/a/a/e;)Ljava/lang/String;
    .locals 3

    new-instance v0, Ljava/lang/StringBuffer;

    invoke-direct {v0}, Ljava/lang/StringBuffer;-><init>()V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "yyyy-MM-dd kk:mm:ss.fff"

    invoke-static {v2}, Lcn/uc/a/a/a/b/j;->j(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "`"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\r\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuffer;->append(Ljava/lang/String;)Ljava/lang/StringBuffer;

    invoke-virtual {v0}, Ljava/lang/StringBuffer;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static b()V
    .locals 4

    sget-boolean v0, Lcn/uc/a/a/a/f;->m:Z

    if-nez v0, :cond_3

    sget-object v0, Lcn/uc/a/a/a/f;->q:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_0
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcn/uc/a/a/a/c;

    invoke-virtual {v0}, Lcn/uc/a/a/a/c;->a()Lcn/uc/a/a/a/e;

    move-result-object v2

    sget-object v3, Lcn/uc/a/a/a/h;->b:Lcn/uc/a/a/a/h;

    invoke-static {v2, v3}, Lcn/uc/a/a/a/f;->a(Lcn/uc/a/a/a/e;Lcn/uc/a/a/a/h;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_1

    invoke-virtual {v0}, Lcn/uc/a/a/a/c;->b()I

    move-result v3

    invoke-static {v2, v3}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;I)V

    :cond_1
    invoke-virtual {v0}, Lcn/uc/a/a/a/c;->c()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v0}, Lcn/uc/a/a/a/c;->a()Lcn/uc/a/a/a/e;

    move-result-object v2

    sget-object v3, Lcn/uc/a/a/a/h;->a:Lcn/uc/a/a/a/h;

    invoke-static {v2, v3}, Lcn/uc/a/a/a/f;->a(Lcn/uc/a/a/a/e;Lcn/uc/a/a/a/h;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_0

    invoke-virtual {v0}, Lcn/uc/a/a/a/c;->b()I

    move-result v0

    invoke-static {v2, v0}, Lcn/uc/a/a/a/f;->a(Ljava/lang/String;I)V

    goto :goto_0

    :cond_2
    const/4 v0, 0x1

    sput-boolean v0, Lcn/uc/a/a/a/f;->m:Z

    :cond_3
    return-void
.end method

.method public static b(Ljava/lang/String;)Z
    .locals 4

    sget-object v0, Lcn/uc/a/a/a/a;->n:Ljava/util/HashMap;

    if-eqz v0, :cond_0

    sget-object v0, Lcn/uc/a/a/a/a;->n:Ljava/util/HashMap;

    invoke-virtual {v0, p0}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    sget-object v0, Lcn/uc/a/a/a/a;->n:Ljava/util/HashMap;

    invoke-virtual {v0, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-lez v0, :cond_0

    const/4 v0, 0x1

    :goto_0
    return v0

    :cond_0
    const/4 v0, 0x0

    goto :goto_0
.end method

.method public static c(Ljava/lang/String;)J
    .locals 2

    sget-object v0, Lcn/uc/a/a/a/a;->n:Ljava/util/HashMap;

    invoke-virtual {v0, p0}, Ljava/util/HashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    sget-object v0, Lcn/uc/a/a/a/a;->n:Ljava/util/HashMap;

    invoke-virtual {v0, p0}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Long;

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    :goto_0
    return-wide v0

    :cond_0
    const-wide/16 v0, 0x0

    goto :goto_0
.end method

.method private static c()V
    .locals 4

    sget-boolean v0, Lcn/uc/a/a/a/f;->n:Z

    if-nez v0, :cond_1

    const-string v0, ""

    :try_start_0
    new-instance v0, Ljava/io/BufferedReader;

    new-instance v1, Ljava/io/InputStreamReader;

    invoke-static {}, Lcn/uc/a/a/a/f;->a()Ljava/io/InputStream;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    const/16 v2, 0x400

    invoke-direct {v0, v1, v2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;I)V

    :goto_0
    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    sget-object v2, Lcn/uc/a/a/a/a;->o:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    sget-object v1, Ljava/lang/System;->err:Ljava/io/PrintStream;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "\u8bfb\u53d6\u5173\u952e\u73af\u8282\u7edf\u8ba1\u5ffd\u7565\u5217\u8868\u9519\u8bef,exception:"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/PrintStream;->print(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    :cond_0
    const/4 v0, 0x1

    sput-boolean v0, Lcn/uc/a/a/a/f;->n:Z

    :cond_1
    return-void
.end method

.method public static declared-synchronized d(Ljava/lang/String;)V
    .locals 4

    const-class v1, Lcn/uc/a/a/a/f;

    monitor-enter v1

    :try_start_0
    sget-object v0, Lcn/uc/a/a/a/a;->n:Ljava/util/HashMap;

    const-wide/16 v2, 0x0

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    invoke-virtual {v0, p0, v2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1

    throw v0
.end method

.method private static e(Ljava/lang/String;)Ljava/io/InputStream;
    .locals 1
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    const/4 v0, 0x0

    return-object v0
.end method
